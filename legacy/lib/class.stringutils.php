<?php

/**
 * Class to Scrape Data from Website
 * @author Jesus Chavez
 */
class StringUtils {

	/** @var curl session */
	function __construct() {
		$paramsNumber=func_num_args();
		if($paramsNumber==0){
			//do something
		}else{
			$this->overload('__construct',func_get_args());
		}
	}
	function __construct1($arg) {
		//do something
	}
	public function myMethod() {
		$paramsNumber=func_num_args();
		if($paramsNumber==0){
			//do something
		}else{
			$this->overload('go',func_get_args());
		}
		
	}
	public static function substringBetween($string, $start, $end, $inclusive = false){ 
		$string = " ".$string; 
		$ini = strpos($string,$start); 
		if ($ini == 0) return ""; 
		if (!$inclusive) $ini += strlen($start); 
		$len = strpos($string,$end,$ini) - $ini; 
		if ($inclusive) $len += strlen($end); 
		return substr($string,$ini,$len); 
	}
	public static function substringAfter($string, $start, $inclusive = false){ 
		$string = " ".$string; 
		$ini = strpos($string,$start); 
		if ($ini == 0) return ""; 
		if (!$inclusive) $ini += strlen($start); 
		$len = strpos($string,$end,$ini) - $ini; 
		return substr($string,$ini,$len); 
	}
	public static function printFields(){
		$this->printArray($this->fields);
	}
	private static function printArray($array){
		array_walk_recursive($array, function($v, $k){  
			$this->println($k.':'.$v);
		});
	}
	public function flat($array, &$return) {
		if (is_array($array)) {
			array_walk_recursive($array, function($a) use (&$return) { flat($a, $return); });
		} else if (is_string($array) && stripos($array, '[') !== false) {
			$array = explode(',', trim($array, "[]"));
			flat($array, $return);
		} else {
			$return[] = $array;
		}
	}
	public static function println ($string_message) {
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
}

?>