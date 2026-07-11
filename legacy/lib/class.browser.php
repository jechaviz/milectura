<?php

/**
 * Class to Scrape Data from Website
 * @author Jesus Chavez
 */
class Browser {

	/** @var curl session */
    private $ch;

    /** @var string path to save cookies */
    private $cookiesPath="cookies.txt";

    /** @var  string user agent */
    private $userAgent;
	
	private $connectTimeout = 15000;
	
	public $source;
	public $baseUrl;
	public $parsedUrl = array();
	public $xpathForm="";
	
	private $charset = "UTF-8";
	private $fieldsList=array();
	private $hiddenFields=array();
	private $fields;
	private $fieldsString;
	private $xPathObj;
	private $form;
	private $formAction;
	private $currentUrl;
	public $xml;
	
	function __construct() {
		$paramsNumber=func_num_args();
		if($paramsNumber==0){
			//do something
		}else{
			$this->overload('__construct',func_get_args());
		}
	}
	function __construct1($url) {
		// Setting URL attribute
		$this->userAgent=$this->getRandomUserAgent();
		$this->go($url);
	}
	function __construct2($url,$postFields) {
		// Setting URL attribute
		$this->__construct1($url);
		$this->go($url,$postFields);
	}
	function __construct3($url,$urlAction,$postFields) {
		// Setting URL attribute
		$this->__construct1($url);
		$this->go($url,$urlAction,$postFields);
	}
	public function go() {
		$paramsNumber=func_num_args();
		if($paramsNumber==0){
			//do something
		}else{
			$this->overload('go',func_get_args());
		}
		
	}
    public function file_get_contents_utf8($url) {
     $content = file_get_contents($url);
      return mb_convert_encoding($content, 'UTF-8',
          mb_detect_encoding($content, 'UTF-8, ISO-8859-1', true));
	}
	public function go1($url) {
		$this->currentUrl=$url;
		$this->setCurl($url);
    	$this->source = curl_exec($this->ch);
		$this->source = $this->file_get_contents_utf8($url);
		$this->xPathObj=$this->returnXpathObject($this->source);
		$this->hiddenFieldsBuilder(array());
		curl_close($this->ch);
		// Executing cURL session        	    
    }
	public function go2($url,$postFields) {
    	// Setting cURL options
		$action=$this->setFormAction($url);
		$this->currentUrl=$action;
		$this->post($action,$postFields);
	}
	public function go3($url,$actionUrl,$postFields) {
    	// Setting cURL options
		$this->currentUrl=$actionUrl;
		$this->post($actionUrl,$postFields);
	}
	public function setCurl($url){
		$this->parsedUrl = parse_url($url);
		$this->baseUrl = $this->parsedUrl['scheme'] .'://' . $this->parsedUrl['host'];
		$this->ch = curl_init(); // Initialising cURL session
		
		//$headers=array(
		//	'Connection: keep-alive',
		//	'Upgrade-Insecure-Requests: 1',
		//	'Content-Type: application/x-www-form-urlencoded',
		//	'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
		//	'Accept-Encoding: gzip, deflate',
		//	'Accept-Language: es-ES,es;q=0.8,en;q=0.6'
		//);
		curl_setopt_array($this->ch, array(
			//CURLOPT_HTTPHEADER=>$headers,
			CURLOPT_COOKIESESSION=> TRUE,  // Use cookies  
			CURLOPT_FOLLOWLOCATION=> TRUE,
			CURLOPT_URL=> $url,
			CURLOPT_TIMEOUT=> $this->connectTimeout,	
			CURLOPT_RETURNTRANSFER=> TRUE,
			CURLOPT_COOKIEFILE=> $this->cookiesPath,
			CURLOPT_COOKIEJAR=> $this->cookiesPath,
			CURLOPT_USERAGENT=> $this->userAgent,
			CURLOPT_AUTOREFERER=> TRUE,
			CURLOPT_SSL_VERIFYPEER=> FALSE,
			//CURLOPT_FAILONERROR=> TRUE,
			//CURLOPT_HEADER=>TRUE,
			//CURLINFO_HEADER_OUT=> TRUE,
			//CURLOPT_VERBOSE => 1,
			CURLOPT_ENCODING=> "gzip"
			//CURLOPT_FILE => $f
		));
	}
	private function post($url,$postFields){
		$this->setCurl($url);
		if(sizeof($this->hiddenFields)==0){
			$this->hiddenFieldsBuilder($postFields);
		}
		$this->fields=array_merge($this->hiddenFields,$postFields);	
    	curl_setopt_array($this->ch, array(
			CURLOPT_POST=> 1,  // Setting method as POST  
			CURLOPT_POSTFIELDS=> http_build_query($this->fields)
		));  // Setting POST 
    	$this->source = curl_exec($this->ch); 
		//$this->printArray(curl_getinfo($this->ch));
		$this->xPathObj=$this->returnXpathObject($this->source);
		curl_close($this->ch);
	}
	/**
     * Method to return XPath object
     * @param  string $item the html object
     * @return object       the XPath object
     */
    
	public function returnXPathObject($item) {
    	$xmlPageDom = new DomDocument();  // Instantiating a new DomDocument object
    	@$xmlPageDom->loadHTML($item);  // Loading the HTML from downloaded page    
    	$xmlPageXPath = new DOMXPath($xmlPageDom);  // Instantiating new XPath DOM object    
    	return $xmlPageXPath;  // Returning XPath object
    }
	public function hiddenFieldsBuilder($postFields) { //void
		$hiddenInputs=$this->xPathObj->query($this->xpathForm."//input[@type='hidden']");
		foreach ($hiddenInputs as $hiddenInput) {
			$name=$hiddenInput->getAttribute('name');
			$value=$hiddenInput->getAttribute('value');
			if (!array_key_exists($name,$this->hiddenFields) && !array_key_exists($name,$postFields))
				$this->hiddenFields[$name]=$value;
		}
	}
	private function setFormXpath(){
		$this->form=$this->xPathObj->query("//form")->item(0);/*->getAttribute('id');
		/*$id=$this->form->getAttribute('id');
		if($$id)
			$this->xpathForm='//form[@id='.$id.']';*/
	}
	private function setFormAction($url){
		$this->setFormXpath();
		$action=$this->form->getAttribute('action');
		if($action){
			$parsedUrl = parse_url($action);
			if($parsedUrl['scheme'])
				return $action;
			else
				return $url;
		}else{
			return $url;
		}
		
	}
	public function getRandomUserAgent(){
		$userAgents=array(
			"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6",
			"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
			"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30)",
			"Opera/9.20 (Windows NT 6.0; U; en)",
			"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; en) Opera 8.50",
			"Mozilla/4.0 (compatible; MSIE 6.0; MSIE 5.5; Windows NT 5.1) Opera 7.02 [en]",
			"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; fr; rv:1.7) Gecko/20040624 Firefox/0.9",
			"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/48 (like Gecko) Safari/48"       
		);
		$random = rand(0,count($userAgents)-1);
		return $userAgents[$random];
	}
	public function printFields(){
		$this->printArray($this->fields);
	}
	private function printArray($array){
		array_walk_recursive($array, function($v, $k){  
			$this->println($k.':'.$v);
		});
	}
	public function println ($string_message) {
		$_SERVER['SERVER_PROTOCOL'] ? print "$string_message<br/>" : print "$string_message\n";
	}
	public function overload($methodName,$params){
		$paramsNumber = sizeof($params)	;
		//methodName1(), methodName2()...
		$methodNumber =$methodName.$paramsNumber;
		if (method_exists($this,$methodNumber)) {
			call_user_func_array(array($this,$methodNumber),$params);
		}else{
			$this->println($methodNumber. ' doesn\'t exists');
		}
	}
	public function urlGetContents(){
		libxml_use_internal_errors(true);
		$doc = new DOMDocument();
		$doc->strictErrorChecking = FALSE;
		$doc->loadHTML(mb_convert_encoding($this->html_content, 'HTML-ENTITIES',  'UTF-8'));
		libxml_use_internal_errors(false);
		$this->xml = simplexml_import_dom($doc);
		return $this->xml;
	}
	/*
	private function formIdentifier($postFields){
		reset($postFields);
		$firstKey=key($postFields);
		if (sizeof($postFields>0))
			$this->form=$this->xPathObj->query('//form');
	}*/
}

?>