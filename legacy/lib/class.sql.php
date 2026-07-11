<?php
/**
 * Class to conect/make operations on db;
 * @author Jesus Chavez
 */
class Db extends Overload{
	private $host;
	private $db;
	private $user;
	private $pass;
	private $prefix;
	private $dbSelected;
	public static $link;
	function __construct5($host,$db,$user,$pass,$prefix) {
		$this->host=$host;
		$this->db=$db;
		$this->user=$user;
		$this->pass=$pass;
		$this->prefix=$prefix;
		$this->connect();
	}
	function __construct4($host,$db,$user,$pass) {
		$this->host=$host;
		$this->db=$db;
		$this->user=$user;
		$this->pass=$pass;
		$this->prefix="";
		$this->connect();
	}
	function __construct3($db,$user,$pass) {
		$this->host="localhost";
		$this->db=$db;
		$this->user=$user;
		$this->pass=$pass;
		$this->prefix="";
		$this->connect();
	}
	public function runSqlScript($file){
		$string = file_get_contents($file);
		$string = preg_replace(
			array('/INSERT\s+INTO\s+`/', '/DROP\s+TABLE\s+IF\s+EXISTS\s+`/', '/CREATE\s+TABLE\s+IF\s+NOT\s+EXISTS\s+`/'),
			array('INSERT INTO `'.$this->prefix, 'DROP TABLE IF EXISTS `'.$this->prefix, 'CREATE TABLE IF NOT EXISTS `'.$$this->prefix),
			$string);
		
		$arr = preg_split('/;(\s+)?\n/', $string);
		foreach ($arr as $v){
			$v = trim($v);
			if (!empty($v)){
				mysql_query($v) or die(mysql_error());
			}
		}
	}
	//http://stackoverflow.com/questions/10054633/insert-array-into-mysql-database-with-php
	public static function insert($table,$array,$link){
		$columns = implode(", ",array_keys($array));
		$escaped_values = array_map('mysql_real_escape_string', array_values($array));
		//$values  = implode(", ", $escaped_values);
		//http://stackoverflow.com/questions/10490860/php-implode-but-wrap-each-element-in-quotes
		$valuesQuoted="'" . implode("', '", $escaped_values) . "'";
		$query = 'insert into '.$table.' ('.$columns.') values ('.$valuesQuoted.')';
		//echo $query;
		mysql_query($query,$link);
	}
	private function connect(){
		Db::$link = @mysql_connect($this->host, $this->user,$this->pass);
		if (!Db::$link) {
			die('No se conectó a la bd: ' . mysql_error());
		}
		
		# mysql_query("SET SESSION time_zone = '-0:00';");
		mysql_query("SET NAMES 'utf8'", Db::$link);
		
		$this->dbSelected = mysql_select_db($this->db, Db::$link);
		if (!$this->dbSelected) {
			die ('No se puede seleccionar la db: ' . mysql_error());
		}
	}
}
?>