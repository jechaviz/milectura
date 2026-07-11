<?php
class FileUtilities{
	public static function forceDownload($filename, $access_type='url') {
    /*
    PHP FORCE DOWNLOAD SCRIPT
    */

    // required for IE, otherwise Content-disposition is ignored
        if (ini_get('zlib.output_compression'))
            ini_set('zlib.output_compression', 'Off');

        if($access_type === 'url') {
        // access type is via the file 's url
            $parsed_url = parse_url($filename);
            $fileinfo = pathinfo($filename);
            $parsed_url['extension'] = $fileinfo['extension'];
            $parsed_url['filename'] = $fileinfo['basename'];
            $parsed_url['localpath'] = $parsed_url['path'];
        }
        else {
        // access type is the local file path
            $fileinfo = pathinfo($filename);
            $parsed_url['localpath'] = $filename;
            $parsed_url['filename'] = basename($filename);
            $parsed_url['extension'] = $fileinfo['extension'];
        }


        // just in case there is a double slash created when joining document_root and path
        $parsed_url['localpath'] = preg_replace('/\/\//', '/', $parsed_url['localpath']);

        if (!file_exists($parsed_url['localpath'])) {
            die('File not found: ' . $parsed_url['localpath']);
        }
        $allowed_ext = array('ics','pdf', 'png', 'jpg', 'jpeg', 'zip', 'doc', 'xls', 'gif', 'exe', 'ppt','ai','psd','odt','xml','sql');
        if (!in_array($parsed_url['extension'], $allowed_ext)) {
            die('This file type is forbidden.');
        }

        switch ($parsed_url['extension']) {
            case "ics": $ctype="text/calendar";
                break;
            case "pdf": $ctype = "application/pdf";
                break;
            case "exe": $ctype = "application/octet-stream";
                break;
            case "zip": $ctype = "application/zip";
                break;
            case "doc": $ctype = "application/msword";
                break;
            case "xls": 
                $ctype = "application/vnd.ms-excel";
                break;
            case "ppt": $ctype = "application/vnd.ms-powerpoint";
                break;
            case "gif": $ctype = "image/gif";
                break;
            case "png": $ctype = "image/png";
                break;
            case "jpeg":
            case "jpg": $ctype = "image/jpg";
                break;
			case "xml": $ctype = "text/xml";
                break;
			case "sql": $ctype = "text/xml";
                break;
            default: $ctype = "application/force-download";
        }
		header("Content-Type: application/force-download");
		header("Content-Type: application/octet-stream");
		header("Content-Type: application/download");
        header("Pragma: public"); // required
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
        header("Cache-Control: private", false); // required for certain browsers
        header("Content-Type: $ctype");
        header("Content-Disposition: attachment; filename=\"" . $parsed_url['filename'] . "\";");
        header("Content-Transfer-Encoding: binary");
        //  header("Content-Length: " . filesize($parsed_url['localpath']));
        readfile($parsed_url['localpath']);
        clearstatcache();
        die();
        exit();
    }
	public static function saveUtf8($filepath,$data){
		//$data = mb_convert_encoding($data, 'UTF-8', 'OLD-ENCODING');
		file_put_contents($filepath,$data);
	}
	public static function file_get_contents_utf8($url) {
		$content = file_get_contents($url);
		return mb_convert_encoding($content, 'UTF-8',mb_detect_encoding($content, 'UTF-8, ISO-8859-1', true));
	}
}
?>