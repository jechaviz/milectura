<?php
/**
 * A simple class which fetches Bing's image of the day with meta data
 */
class BingPhoto {
    // Constants
    const TOMORROW = -1;
    const TODAY = 0;
    const YESTERDAY = 1;
    const LIMIT_N = 8; // Bing's API returns at most 8 images
    const RESOLUTION_LOW = '1366x768';
    const RESOLUTION_HIGH = '1920x1080';
    // API
    const BASE_URL = 'http://www.bing.com';
    const JSON_URL = '/HPImageArchive.aspx?format=js';
    private $args;
    private $data;
	public function __construct(){}
    /**
     * Constructor: Fetches image(s) of the day from Bing
     * @param int $date Date offset. 0 equals today, 1 = yesterday, and so on.
     * @param int $n Number of images / days
     * @param string $locale Localization string (en-US, de-DE, ...)
     * @param string $resolution Resolution of images(s)
     */
    /*public function __construct($date = self::TODAY, $n = 1, $locale = 'en-US', $resolution = self::RESOLUTION_HIGH) {
        $this->setArgs(array(
            'date'       => $date,
            'n'          => $n,
            'locale'     => $locale,
            'resolution' => $resolution
        ));
        try {
            $this->fetchImages();
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }*/
    /**
     * Returns exactly one fetched image
     * @return array The image array with its URL and further meta data
     */
    public function getImage() {
        $image = $this->getImages(1);
        return $image[0];
    }
    /**
     * Returns n fetched images
     * @param int $n Number of images to return
     * @return array Image data
     */
    public function getImages($n = 1) {
        $n = max($n, count($this->data));
        return array_slice($this->data, 0, $n);
    }
    /**
     * Returns the class arguments
     * @return array Class arguments
     */
    public function getArgs() {
        $this->sanityCheck();
        return $this->args;
    }
    /**
     * Sets the class arguments
     * @param array $args
     */
    public function setArgs($args = array()) {
        $this->args = array_replace(array (
            'date'       => self::TODAY,
            'n'          => 1,
            'locale'     => 'en-US',
            'resolution' => self::RESOLUTION_HIGH
        ), $args);
        $this->sanityCheck();
		 try {
            $this->fetchImages();
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    /**
     * Performs some sanity checks
     * @return array Validated arguments
     * @internal param array $args Class arguments
     */
    private function sanityCheck() {
        if ($this->args['date'] < self::TOMORROW) {
            $this->args['date'] = self::TOMORROW;
        }
        if ($this->args['n'] > self::LIMIT_N) {
            $this->args['n'] = self::LIMIT_N;
        }
        if ($this->args['n'] < 1) {
            $this->args['n'] = 1;
        }
        if (false === in_array($this->args['resolution'], array(self::RESOLUTION_LOW, self::RESOLUTION_HIGH))) {
            $this->args['resolution'] = self::RESOLUTION_HIGH;
        }
    }
    /**
	 * Fetches the image JSON data from Bing
     * @throws Exception
     */
    private function fetchImages() {
        // Constructing API url
        $url = self::BASE_URL . self::JSON_URL
            . '&idx=' . $this->args['date']
            . '&n=' . $this->args['n']
            . '&mkt=' . $this->args['locale'];
        try {
            $this->data = $this->fetchJSON($url);
            $this->data = $this->setQuality($this->data['images']);
        } catch (Exception $e) {
            throw $e;
        }
    }
    /**
     * Fetches an associative array from given JSON url
     * @param  string $url JSON URL
     * @return array Associative data array
     * @throws Exception
     */
    private function fetchJSON($url) {
		$json=file_get_contents($url);
		echo 'json:'.$json;
        $data  = json_decode($json, true);
        $error = json_last_error();
        if ($data !== null && $error === JSON_ERROR_NONE) {
            return $data;
        } else {
            throw new Exception('Unable to retrieve JSON data: ' . $error);
        }
    }
    /**
     * Sets the image resolution
     * @param array $images Array with image data
     * @return array Modified image data array
     */
    private function setQuality($images) {
        foreach ($images as $i => $image) {
            $images[$i]['url'] = self::BASE_URL . str_replace(
                self::RESOLUTION_HIGH, $this->args['resolution'], $image['url']
            );
        }
        return $images;
    }
	//version php 5.2.17, existe de 5.3 pa arriba.
	private function array_replace(array &$array, array &$array1 ){
		$args = func_get_args();
		$count = func_num_args();

		for ($i = 0; $i < $count; ++$i) {
		  if (is_array($args[$i])) {
			foreach ($args[$i] as $key => $val) {
			  $array[$key] = $val;
			}
		  }
		  else {
			trigger_error(
			  __FUNCTION__ . '(): Argument #' . ($i+1) . ' is not an array',
			  E_USER_WARNING
			);
			return NULL;
		  }
		}
		return $array;
	  }
	  public function saveImage2($inPath,$outPath){ //Download images from remote server
		$in=    fopen($inPath, "rb");
		$out=   fopen($outPath, "wb");
		while ($chunk = fread($in,8192))
		{
			fwrite($out, $chunk, 8192);
		}
		fclose($in);
		fclose($out);
		return $outPath;
	 }
	public function saveImage($url,$filename){
		if(!file_exists($filename)){
			$fp = fopen($filename,'w');
			if($fp){
				$ch = curl_init ($url);
				curl_setopt($ch, CURLOPT_HEADER, 0);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
				curl_setopt($ch, CURLOPT_BINARYTRANSFER, 1);
				$result = parse_url($url);
				curl_setopt($ch, CURLOPT_REFERER, $result['scheme'].'://'.$result['host']);
				curl_setopt($ch, CURLOPT_USERAGENT,'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101 Firefox/45.0');
				$raw=curl_exec($ch);
				curl_close ($ch);
				if($raw){
					fwrite($fp, $raw);
				}
				fclose($fp);
				if(!$raw){
					@unlink($filename);
					return false;
				}
				return true;
			}
			return false;
		}
		return true;
	}
	public function getBingImageUrl(){
		/*if($s == 'big'){
			$str = file_get_contents('http://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=es-MX');
			$array = json_decode($str);
			$imgurl = $array->{"images"}[0]->{"url"};
			if($imgurl){
				return $imgurl;
			}else{
				return;
			}
		}else{*/
			$url='http://cn.bing.com/HPImageArchive.aspx?idx=0&n=8&mkt=es-MX';
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $url);
			curl_setopt($ch,CURLOPT_USERAGENT,"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13");
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			$str = curl_exec($ch);
			curl_close($ch);
			//echo $str.'<br/>';
			//idx=fecha 0=hoy 1=ayer -1=mañana; n=num de imagenes,
			if(preg_match_all("/<url>(.+?)<\/url>/is",$str,$matches)){
				$i=rand(0,7);
				$imgurl='http://cn.bing.com'.$matches[1][$i];
			}
			if($imgurl){		
				return $imgurl;
			}else{
				return;
			}
		/*}*/
	}
	public function bingImage(){
		$imageUrl=$this->getBingImageUrl();
		$imageName=basename($imageUrl);
		$imageName=preg_replace('/(.+)?\.(\w+)(_ROW[^_]+)_\d+x\d+(.jpg)(.+)?/ism','$2$4',$imageName);
		//echo '<span>imagePath:'.$imagePath.'<span>';
		$imagePath='assets/images/'.$imageName;
		if(strpos($imagePath,'bing.com')!==-1){
			if (!file_exists($imagePath)) {
				$this->saveImage2($imageUrl,$imagePath);
			}
		}else{
			$imagePath='assets/images/'.$this->random_pic();
		}
		return $imagePath;
	}
	private function random_pic($dir = __DIR__.'assets/images/'){
		$files = glob($dir . '/*.jpg');
		$file = array_rand($files);
		return $files[$file];
	}
}

/*
$bing  = new BingPhoto(BingPhoto::YESTERDAY, 1, 'es-MX', BingPhoto::RESOLUTION_LOW);
foreach ($bing->getImages() as $image) {
    printf('<img src="%s">', $image['url']);
}
*/
/*$bing = new BingPhoto();
$bing->bingImage();*/