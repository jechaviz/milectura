<?php
	class DateUtils {
		public static function format($dateString,$formatFrom,$formatTo){
			$date=DateTime::createFromFormat($formatFrom, $dateString);
			$date=$date->format($formatTo);
			return $date;
		}
		public static function validateDate($date,$format){
			$d = DateTime::createFromFormat($format, $date);
			return $d && $d->format($format) === $date;
		}
	}
?>