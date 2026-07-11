<?php

class Passage{
  public $title;
  public $text;
  public $reference;
}

class BibleGateway2{
  const baseURL = 'https://www.biblegateway.com';
  public $md;
  public $pug;
  public $html;
  public $version;
  public $mdPassages = [];
  public $passagesTitle = [];
  public $titles=[];
  public Passage $mdOtPassage;
  public Passage $mdNtPassage;
  public Passage $htmlOtPassage;
  public Passage $htmlNtPassage;
  public Passage $votdPassage;
  public $searches = [];
  
  public function __construct($version){
    $this->version = $version?$version:'RVR1960';
    $this->mdOtPassage   = new Passage();
    $this->mdNtPassage   = new Passage();
    $this->htmlOtPassage = new Passage();
    $this->htmlNtPassage = new Passage();
    $this->votdPassage   = new Passage();
  }

  /*
    Gets a daily reading passage in md format
  */
  
  public function getTodayReading($version){
    $version = $version?$version:$this->version;
    self::getDailyReadingPassages($version,date("Y"),date("m"),date("d"));
  }
  
  public function getDailyReadingPassages($version,$year,$month,$day){
    if(!$year||!$month||!$day) return;
    $version = $version?$version:$this->version;
    $url = self::baseURL."/reading-plans/old-new-testament/$year/$month/$day?version=$version&interface=print";
    $xpathPassagesName=".//*[@class='rp-passage-display'][1]";
    $xpathPassages ="//*[@id='rp-passage-0']|//*[@id='rp-passage-1']";
    $xpathLines    =".//span[text()]";
    self::getMdPassages($url,$xpathPassagesName,$xpathPassages,$xpathLines);
    $this->mdNtPassage->text    = $this->mdPassages[0];
    $this->mdOtPassage->text    = $this->mdPassages[1];
    $this->htmlNtPassage->title = $this->passagesTitle[1]; 
    $this->htmlOtPassage->title = $this->passagesTitle[0];
    $this->htmlNtPassage->text  = self::md2Html($this->mdPassages[0]);
    $this->htmlOtPassage->text  = self::md2Html($this->mdPassages[1]);
    self::showHtml($version);
  }
  
  /*
    Gets a searched passage in md format
  */
  
  public function setMdPassages($version,$search){
    if(!$search) return;
    $version = $version?$version:$this->version;
    $url = self::baseURL."/passage/?search=$search&version=$version&interface=print";
    $xpathPassagesName=".//*[@class='bcv']/*/*";
    $xpathPassages ="//*[contains(@class, 'passage-table')]";
    $xpathLines    =".//*[contains(@class,'passage-content')]//span[contains(@class,'text')]|.//*[contains(@class,'passage-content')]//*[contains(name(),'h')]";
    self::getMdPassages($url,$xpathPassagesName,$xpathPassages,$xpathLines,$version);
  }
  public function getHtmlPassages($version,$search){
    if(!$search) return;
    self::setMdPassages($version,$search);
    self::showHtml($version);
  }
  
  public function showHtml($version){
    self::createMd($version);
    self::createHtml();
    $html = file_get_contents("passage.html");
    echo($html);
  }
  
  /*
    Gets a passage in md format
  */
  public function getMdPassages($url,$xpathPassagesName,$xpathPassages,$xpathLines){
    //unlink('rd.html');
    //unlink('parents.html');
    //unlink('lines.html');
    $this->passagesTitle = [];
    $this->mdPassages = [];
    $html = file_get_contents($url);
    
    $dom = new DOMDocument();
    libxml_use_internal_errors(true);
    $dom->loadHTML($html);
    libxml_clear_errors();
    $xpath = new DOMXpath($dom);
    $passages =  $xpath->query($xpathPassages);
    $passagesNumber = $passages->length;
    //echo($passagesNumber);
    if($passagesNumber > 0) {
      $mdPassage='';
      $cleanTextRegex = [
        '/^\s*/m', //remover espacios al inicio
        '/\(\w+\)/m', //remover parentesis
        '/\[\w+\]/m' //remover corchetes
      ];
      $cleanMdChars = [
        '»',
        '«'
      ];
      foreach ($passages as $passage) {
        //Debug
        //file_put_contents('rd.html', $dom->saveXML($passage).PHP_EOL,FILE_APPEND);
        $passageTitle = $xpath->query($xpathPassagesName, $passage);
        $passageTitle = $passageTitle->item(0);
 
        if($passageTitle){
          $passageTitle = preg_replace('/^\s*/', '', $passageTitle->textContent);
          $mdPassage.=PHP_EOL."## $passageTitle";
          array_push($this->passagesTitle,$passageTitle);
        }
        $lines = $xpath->query($xpathLines, $passage);
        foreach ($lines as $line) {
          $lineParent = $xpath->query("parent::*", $line)[0];
          $parentNodeName = $lineParent->nodeName;
          $nodeName = $line->nodeName;
          if(strpos('h3,h4,p,span',$parentNodeName)== false &&
             strpos('h3,h4,p,span',$nodeName)== false) continue;
          //filtering
          $lineParentClassAttr = $lineParent->attributes->getNamedItem('class');
          $lineParentClassAttrValue='';
          if($lineParentClassAttr) $lineParentClassAttrValue = $lineParentClassAttr->value;
          if(strpos($lineParentClassAttrValue,'reference')!== false) continue;
          if(strpos($lineParentClassAttrValue,'foot')!== false) continue;
          $lineClassAttr = $line->attributes->getNamedItem('class');
          $lineClassAttrValue='';
          if($lineClassAttr) $lineClassAttrValue = $lineClassAttr->value;
          if(strpos($lineClassAttrValue,'reference')!== false) continue;
          if(strpos($lineClassAttrValue,'foot')!== false) continue;
          $lineText = $line->textContent;
          if(preg_replace('/\s*/m','',$lineText)=='') continue;
          if(strpos($lineText,'Cross references')!== false) continue;
          //Debug
          //file_put_contents('lines.html', $dom->saveXML($line).PHP_EOL,FILE_APPEND);
          //file_put_contents('parents.html', $dom->saveXML($lineParent).PHP_EOL,FILE_APPEND);
          //Process non filtered lines
          foreach($cleanTextRegex as $regex) {
            $lineText = preg_replace($regex, '', $lineText);
          }
          //
          $lineChilds = $xpath->query("*", $line)[0];
          //Process
          $chapter = $xpath->query(".//*[contains(@class, 'chapternum')]", $line)[0];
          $verseNum = $xpath->query(".//*[contains(@class, 'versenum')]", $line)[0];
          
          $sectionTitle = 
          (strpos($parentNodeName.$nodeName,'h3')!== false?PHP_EOL.PHP_EOL."#### $lineText":
          (strpos($parentNodeName.$nodeName,'h4')!== false?PHP_EOL.PHP_EOL."#### $lineText":''));
          $chapter = $chapter?PHP_EOL."### Capítulo $chapter->textContent".PHP_EOL.PHP_EOL:'';
          if($sectionTitle!='')
            if(strpos($sectionTitle,'####')==false)
              array_push($this->titles,$sectionTitle);
          if($chapter!='')
            array_push($this->titles,$chapter);
          $verseNum = $verseNum?$verseNum->textContent:'';
          $verseNum = $chapter?1:$verseNum;
          $verse = $sectionTitle==''?$lineText:'';
          $newLine ='';
          if($sectionTitle!='')
            $newLine = $sectionTitle;
          if($verse!=''){
            $verse = preg_replace('/^\d+/','',$verse);
            if($verseNum!='')
              $newLine = PHP_EOL."$chapter$verseNum. $verse";
            else
              $newLine = " $verse";
          }
          foreach($cleanMdChars as $char) {
            $newLine = str_replace($char, '', $newLine);
          }
          $newLine = str_replace(' ','', $newLine);
          $mdPassage.=$newLine;
        }
        array_push($this->mdPassages,$mdPassage.PHP_EOL);
        $mdPassage="";
      }
    }
  }
  
  public function getVerseOfTheDay($version){
    $version = $version?$version:$this->version;
    self::getVerseOfDay($version,date("Y"),date("m"),date("d"));
    self::showVOTD();
  }
  
  public function showVOTD(){
    echo($this->votdPassage->reference.'. '.
         $this->votdPassage->text.' ('.
         $this->version.')'
    );
  }
  
  public function getVerseOfDay($version,$year,$month,$day){
    $version = $version?$version:$this->version;
    $url = self::baseURL.'/votd/get/?'.http_build_query(['format' => 'json', 'version' => $version,'year'=>$year,'month'=>$month,'day'=>$day]);
    $votd = json_decode(file_get_contents($url))->votd;
    $this->votdPassage->text = $votd->text;
    $this->votdPassage->reference = $votd->display_ref;
    return $this;
  }
  
  public function createMd($version){
    foreach($this->mdPassages as $passage) {
       $this->md.= $passage.PHP_EOL;
    }
    file_put_contents("passage.md", "#### ".$version.PHP_EOL.PHP_EOL.$this->md);
  }
  
  public function createPug(){
    self::mdFileToPug('passage');
  }
  
  public function createHtml(){
    if(!$this->pug)
      self::mdFileToPug('passage');  
    self::pugFileToHtml('passage');
  }
  
  public function md2Pug($md){
    $pug = $md;
    // Regex for markdown convertion to pug
    $md2pugRegex = [
      '/([\r?\n]+)([\t ]*)(\d+\.? ?.*)/m' => '$1oli $2$3', 
      '/^([\t ]*)(\d+\.? ?.*)(\r?\n\r?\n)/m' => '.oli $2$3$4',
      '/^(oli .+\r?\n)(\r?\n)/m' => '$1.oli$2$2',
      '/^(oli .+\r?\n)o(li)/m' => '$1$2',
      '/^(li .+\r?\n)o(li)/m' => '$1$2',
      '/^([\t ]*)\-(.*)/m' => 'li $1$2',
      '/^###### (.*)/m' => 'h6 $1',
      '/^##### (.*)/m' => 'h5 $1',
      '/^#### (.*)/m' => 'h4 $1',
      '/^### (.*)/m' => 'h3 $1',
      '/^## (.*)/m' => 'h2 $1',
      '/^# (.*)/m' => 'h1 $1',
      '/\*\*(.*)\*\*/m' => 'strong $1',
      '/\*(.*)\*/m' => 'em $1',
      '/~~(.*)~~/m' => 'del $1'
      //'/^(.*)$/m', 'p $1'
    ];
    foreach($md2pugRegex as $regex=>$replace) {
      $pug = preg_replace($regex, $replace, $pug);
    }
    return $pug;
  }
  
  public function mdFileToPug($fileName){
    $md = file_get_contents("$fileName.md");
    $pug = self::md2Pug($md);  
    file_put_contents("$fileName.pug", $pug);
    $this->pug=$pug;
  }
  
  public function pug2Html($pug){
    $html = $pug;
    // Regex for markdown convertion to pug
    $pug2html = [
      '/^h1 (.+)/m' => '<h1>$1</h1>',
      '/^p (.+)/m' => '<p>$1</p>',
      '/^h2 (.+)/m' => '<h2>$1</h2>',
      '/^h3 (.+)/m' => '<h3>$1</h3>',
      '/^h4 (.+)/m' => '<h4>$1</h4>',
      '/^h5 (.+)/m' => '<h5>$1</h5>',
      '/^h6 (.+)/m' => '<h6>$1</h6>',
      '/^div (.+)/m' => '<div>$1</div>',
      '/^span (.+)/m' => '<span>$1</span>',
      '/^\.oli/m' => '</ol>',
      '/^a ([^\S]+) (.+)/m' => '<a href="$1" alt="$2">$2</a>',
      '/^oli (\d+)\.?\s*(.+)/m' => '<ol start="$1">'.PHP_EOL.'<!--$1--><li>$2</li>',
      '/^([o|u])li (.+)/m' => '<$1l>'.PHP_EOL.'<li>$2</li>',
      '/^\.([o|u])li (\d*)\.?\s*(.+)/m' => '<!--$2--><li>$3</li>'.PHP_EOL.'</$1l>',
      '/^\.([o|u])l$/m' => '</$2l>',
      '/^li (\d*)\.?\s*(.+)/m' => '<!--$1--><li>$2</li>',
      '/\r</m' => '<',
      '/ start="1"/m' => ''
      
    ];
    //Loop over the regex array
    foreach($pug2html as $regex=>$replace) {
      $html = preg_replace($regex, $replace, $html);
    }
    return $html;
  }
   
  public function pugFileToHtml($fileName){
    $pug = file_get_contents("$fileName.pug");
    $html = '<html><body>'.self::pug2html($pug).'</body></html>';
    file_put_contents("$fileName.html", $html);
    $this->html=$html;
  }
  
  public function md2Html($md){
    $pug = self::md2Pug($md);
    $html = '<html><body>'.self::pug2html($pug).'</body></html>';
    return $html;
  }
  
}
$bg= new BibleGateway2('NTV');
//$bg->getTodayReading('NTV');
//$bg->getVerseOfTheDay('RVR1960');
//$bg->getPassages('NTV',"Mateo 5-7");
//$bg->getHtmlPassages('NTV','Mateo 5:3-5,Juan 2:1,Apocalipsis 3:16');
$bg->getHtmlPassages('RVR1960','Apocalipsis 21, Zacarías 13-14');
//$bg->setHtml();
?>