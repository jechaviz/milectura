<?php
class XmlUtilities{
	public static function transformStr($xmlString,$xslPath){
		$xml=new DOMDocument;
		$xsl=new DOMDocument;
		$xml->loadXML($xmlString);
		$xsl->load($xslPath);
		return XmlUtilities::transform($xml,$xsl);
	}
	public static function transformFile($xmlPath,$xslPath){
		$xml=new DOMDocument;
		$xsl=new DOMDocument;
		$xml->load($xmlPath);
		$xsl->load($xslPath);
		return XmlUtilities::transform($xml,$xsl);
	}
	private static function transform($xml,$xsl){
		$proc = new XSLTProcessor;
		$proc->importStyleSheet($xsl); // adjunta las reglas XSL
		echo $proc->transformToXML($xml);
	}
	public static function xml2Json($xmlstring){
		$xml = simplexml_load_string($xmlstring);
		$json = json_encode($xml);
		return $json;
	}
	public static function json2xml($json){
		$array = json_decode($json, true);
		$xml= XmlUtilities::array2xml($array);
		return $xml;
	}
	public static function array2xml($array, $parentkey="", $xml = false){
	   if($xml === false){
		   $xml = new SimpleXMLElement('<result/>');
	   }
	   foreach($array as $key => $value){
		   if(is_array($value)){
			   XmlUtilities::array2xml($value, is_numeric((string) $key)?("n".$key):$key, $xml->addChild(is_numeric((string) $key)?$parentkey:$key));
		   } else {
				//$xml->addAttribute, si quiero atributos.
			   $xml->addChild(is_numeric((string) $key)?("n".$key):$key, $value);
		   }
	   }
	   return $xml->asXML();
	}
}
?>