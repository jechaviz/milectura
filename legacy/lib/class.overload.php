<?php

/**
 * Class to execute Wsdl in Juniper
 * @author Jesus Chavez
 */
class Overload{
	function __construct() {
		$paramsNumber=func_num_args();
		if($paramsNumber==0){
			//do something
		}else{
			$this->overload('__construct',func_get_args());
		}
	}
	public function overload($methodName,$params){
		$paramsNumber = sizeof($params);
		//methodName1(), methodName2()...
		$methodNumber =$methodName.$paramsNumber;
		if (method_exists($this,$methodNumber)) {
			call_user_func_array(array($this,$methodNumber),$params);
		}else{
			echo ($methodNumber. ' doesn\'t exists');
		}
	}
}