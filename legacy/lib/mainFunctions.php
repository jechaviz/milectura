<?php
	function getReadingOfTheDay($version,$year,$month,$day){
		$dir=$_SERVER['DOCUMENT_ROOT'].'/archive/'.$version.'/'.$year.'/'.$month.'/';
		if (!is_dir($dir)) {
			mkdir($dir, 0777, true);
		}
		$archive=$dir.$day.'.html';
		if (!file_exists($archive)) {
			//in 01.head.php
			$metaDescription='Aquí podrás leer la lectura de cada día del año en tu idioma favorito'; 
			//in 02.title.php
			$title='MI LECTURA DIARIA'; 
			$logoUrl='../../../../assets/images/biblia-300x300-68.png';
			$votdTitle='Versículo para hoy';
			//in 03.votd.php
			$bible = new BibleGateway($version);
			$votd = $bible->getVerseOfTheDay($year,$month,$day);
			$verse = $bible->reference;
			$quote = '<div id="votd" class="mbr-hero__subtext normal">'.htmlEntitiesReplace($bible->text).'</div>';
			$versionText=$bible->versionText;
			$bibleVersion=$bible->versionText;
			//$quote = preg_replace('/</?span[^"]+>/','',$quote);
			$bing = new BingPhoto();
			//in 04.lecturaDelDia.php
			$lddTitle='LECTURA DEL DIA';
			$bible->getReadingOfTheDayOldTestament($year,$month,$day);
			$atReadingText=$bible->text;
			$atReadingTitle=$bible->reference;
			$bible->getReadingOfTheDayNewTestament($year,$month,$day);
			$ntReadingText=$bible->text;
			$ntReadingTitle=$bible->reference;
			$readingTitle='<h5 class="lddTitle">'.$bible->versionText.
						  '<br/>'.
						  "<a href='#nt'>".$ntReadingTitle."</a>".
						  '<br/>'.
						  "<a href='#ot'>".$atReadingTitle."</a>".
						  '</h5>';
			ob_start();
			include_once('dailyReading/00.main.php');
			$rod = ob_get_clean(); //reading of the day
			FileUtilities::saveUtf8($archive,$rod);
			include($archive);
		}else{
			include($archive);
		}
	}

	function println ($string_message) {
		$_SERVER['SERVER_PROTOCOL'] ? print "$string_message<br/>" : print "$string_message\n";
	}

	function htmlEntitiesReplace($rb){
		$rb = str_replace("&ldquo;", "“", $rb);
		$rb = str_replace("&rdquo;", "”", $rb);
		$rb = str_replace("&#225;", "á", $rb);
		$rb = str_replace("&#233;", "é", $rb);
		$rb = str_replace("&#237;", "í", $rb);
		$rb = str_replace("&#243;", "ó", $rb);
		$rb = str_replace("&#250;", "ú", $rb);
		$rb = str_replace("&#241;", "ñ", $rb);
		return $rb;
	}

	function search($version,$passage){
		$dir=$_SERVER['DOCUMENT_ROOT'].'/archive/'.$version.'/searches/';
		if (!is_dir($dir)) {
			mkdir($dir, 0777, true);
		}
		$name=preg_replace('/:/m','_',$passage);
		$archive=$dir.$name.'.html';
		if (!file_exists($archive)) {
			//in 01.head.php
			$metaDescription='Palabra de Dios en mi ❤️'; 
			//in 02.title.php
			$title='GUARDADO EN MI CORAZON';
			$logoUrl='../../../../assets/images/biblia-300x300-68.png';
			//in 03.votd.php
			$bible = new BibleGateway2($version);
			$thisYear=date("Y");
			$thisMonth=date("m");
			$thisDay=date("d");
			$votd = $bible->getVerseOfTheDay($version,$thisYear,$thisMonth,$thisDay);
			$verse = $bible->reference;
			$quote = '<div id="votd" class="mbr-hero__subtext normal">'.htmlEntitiesReplace($bible->text).'</div>';
			$versionText=$bible->versionText;
			$bibleVersion=$bible->versionText;
			//$quote = preg_replace('/</?span[^"]+>/','',$quote);
			$bing = new BingPhoto();
			//in 04.lecturaDelDia.php
			$lddTitle='PASAJES';
			$passages=$bible->getPassages($version,$passage);
			$text='';
			foreach($passages as $p){
				$text.=$p->text;
			}
			$ntReadingText=$bible->text;
			$readingTitle='<h5 class="lddTitle">'.$bible->versionText.
						  '<br/>'.
						  "<a href='#nt'>".$search."</a>".
						  '</h5>';
			ob_start();
			include_once('dailyReading/00.main.php');
			$rod = ob_get_clean(); //reading of the day
			FileUtilities::saveUtf8($archive,$rod);
			//include($archive);
		}else{
			include($archive);
		}
	}
?>