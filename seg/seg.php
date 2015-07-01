<?php
for ($x=232; $x<=232; $x++) {

	$ch = curl_init();
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_URL, 'https://clarin.phonetik.uni-muenchen.de/BASWebServices/services/runMAUSBasic');
	$post = array(
	"OUTFORMAT"=>"TextGrid",
	"NOINITIALFINALSILENCE"=>"false",
	"INSKANTEXTGRID"=>"true",
	"LANGUAGE"=>"eng-US",
	"TEXT"=>"@/Applications/XAMPP/xamppfiles/htdocs/seg/words.txt",  //the path of the text of your audio
	"INSORTTEXTGRID"=>"true",
	"USETRN"=>"force",
	"SIGNAL"=>"@/Applications/XAMPP/xamppfiles/htdocs/seg/english/english".$x.".wav"   //the path of the audio
	);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post); 
	$response = curl_exec($ch);

	if(curl_errno($ch))
	{
	    echo 'error:' . curl_error($ch);
	}


	$xml = simplexml_load_string($response);
	$dl = $xml->downloadLink;


	$ch2 = curl_init();
	curl_setopt($ch2, CURLOPT_URL, $dl);
	curl_setopt($ch2, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch2, CURLOPT_SSL_VERIFYPEER, false);
	$grid = curl_exec($ch2);
	if(curl_errno($ch2))
	{
	    echo 'error:' . curl_error($ch2);
	}
	//print_r($grid);

	$des = "/Applications/XAMPP/xamppfiles/htdocs/seg/grid/english".$x.".TextGrid";  //the path where you save the output
	$file = fopen($des, "w");
	fwrite($file, $grid);
	fclose($file);

	curl_close ($ch);
	curl_close ($ch2);
}
?>