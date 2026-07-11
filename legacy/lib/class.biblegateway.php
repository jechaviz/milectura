<?php
class BibleGateway{
	//https://github.com/benjamindoe/BibleGateway/blob/master/tests/index.php, customized
	const URL = 'http://www.biblegateway.com';
	protected $version;
	protected $versionText;
	protected $reference;
	protected $text = '';
	protected $copyright = '';
	protected $permalink;
	protected $readingOfTheDayHtml = '';
  protected $plan = 'old-new-testament';
	public function __construct($version = 'RVR1960'){
		$this->version = $version;
	}
	public function __get($name){
		if ($name === 'permalink'){
			return $this->permalink = self::URL.'/passage?'.http_build_query(['search' => $this->reference,'version' => $this->version,'interface'=>'print']);
		}
		return $this->$name;
	}
	public function __set($name, $value){
		if(in_array($name, ['version', 'reference'])){
			$this->$name = $value;
			$this->searchPassage($this->reference);
		}
	}
	public function getReadingOfTheDayNewTestament($year,$month,$day){
		$this->getReadingOfTheDay($year,$month,$day,1);
	}
	public function getReadingOfTheDayOldTestament($year,$month,$day){
		$this->getReadingOfTheDay($year,$month,$day,0);
	}
	public function getReadingOfTheDay($year,$month,$day,$testament){
		$text = '';
		//load from biblegateway
		if($this->readingOfTheDayHtml==''){
			$url=self::URL.'/reading-plans/'.$this->plan.'/'.$year.'/'.$month.'/'.$day.'?version='.$this->version.'&interface=print';
			$this->readingOfTheDayHtml = file_get_contents($url);
		}
		$dom = new \DOMDocument;
		libxml_use_internal_errors(true);
		$dom->loadHTML($this->readingOfTheDayHtml);
		libxml_use_internal_errors(false);
		$xpath = new \DOMXPath($dom); 
		$reading = $xpath->query("//*[@class='rp-passage']")[$testament];
		$title=$xpath->query("./*/*[@class='rp-passage-display']",$reading)[0];
		$this->reference=$title->nodeValue;
		//get content
		$content =  $xpath->query("./*[@class='rp-passage-text text-html']",$reading)[0];
		$pararaphs =  $xpath->query(".//*[contains('h3,p',name())]",$content);
		//$verses = $xpath->query("//div[@class='passage-wrap']//span[contains(@class, 'text')]");
		//start building output
		$text.='<h3>'.$title->textContent.'</h3>';
		$crossrefHtml='';
		foreach ($pararaphs as $paragraph){
			if($xpath->query('.//span[contains(@class, "text")]', $paragraph)->length){
				$results = $xpath->query(".//sup[contains(@class, 'crossreference') or contains(@class, 'footnote')] | .//div[contains(@class, 'crossrefs') or contains(@class, 'footnotes')]", $paragraph);
				//clean and change crossref to tooltips
				foreach($results as $result){
					//evaluate get the xpath evaluation
					$dataTooltipContent=$xpath->evaluate('string(@data-cr)',$result);
					//separate # from Id to use in xpath xpresion
					$id=explode('#',$dataTooltipContent)[1];
					//look for crossref
					$ref = $xpath->query("//li[@id='".$id."']/a[@class='crossref-link']", $reading)[0];
					$link = $xpath->evaluate("string(@href)", $ref);
					$linkRef = $xpath->evaluate("string(@data-bibleref)", $ref);
					$url=self::URL.$link;
					//get crossref content from biblegateway
					$crossref=$this->parseHtml($url);
					//build html for tooltip
					$crossrefHtml.= '<div data-bibleref="'.$linkRef.'" id="'.$id.'">'.$crossref.'</div>';
					$paragraph->setAttribute('data-tooltip-content',$dataTooltipContent);
					//$class=$paragraph->getAttribute('class');
					$paragraph->setAttribute('class','withCrossRef');
					//remove old html with crossref link
					$result->parentNode->removeChild($result);
				}
				$text .= $dom->saveHTML($paragraph);
			}
			else{
				$this->copyright = $dom->saveHTML($paragraph);
			}
		}
		$this->text=$text.'<div class="crossreferences hidden">'.$crossrefHtml.'</div><!--.crossreferences-->';
		return $this;
	}
	private function parseHtml($url){
		$text='';
		$html = file_get_contents($url);
		$dom = new \DOMDocument;
		libxml_use_internal_errors(true);
		$dom->loadHTML($html);
		libxml_use_internal_errors(false);
		$xpath = new \DOMXPath($dom);
		$context = $xpath->query("//div[@class='passage-wrap']")->item(0);
		$pararaphs =  $xpath->query("//div[@class='passage-wrap']/*/*[contains(@class,'result')]");
		$verses = $xpath->query("//div[@class='passage-wrap']//span[contains(@class, 'text')]");
		foreach ($pararaphs as $paragraph){
			if($xpath->query('.//span[contains(@class, "text")]', $paragraph)->length){
				$results = $xpath->query(".//sup[contains(@class, 'crossreference') or contains(@class, 'footnote')] | .//div[contains(@class, 'crossrefs') or contains(@class, 'footnotes')] | .//span[@class='passage-display-version']", $paragraph);
				foreach($results as $result){
					$result->parentNode->removeChild($result);
				}
				$text .= $dom->saveHTML($paragraph);
			}
			else{
				$this->copyright = $dom->saveHTML($paragraph);
			}
		}
		return $text;
	}
	public function searchPassage($passage){
		$this->reference = $passage;
		$url = self::URL.'/passage?'.http_build_query(['search' => $passage,'version' => $this->version,'interface'=>'print']);
		$this->text=$this->parseHtml($url);
		return $this;
	}
	public function getVerseOfTheDay($year,$month,$day){
		$url = self::URL.'/votd/get/?'.http_build_query(['format' => 'json', 'version' => $this->version,'year'=>$year,'month'=>$month,'day'=>$day]);
		$votd = json_decode(file_get_contents($url))->votd;
		$this->text = $votd->text;
		$this->reference = $votd->display_ref;
		$this->versionText = $votd->version;
		$this->permalink = $votd->permalink;
		return $this;
	}
}