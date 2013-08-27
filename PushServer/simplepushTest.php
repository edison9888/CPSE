<?php

require_once('IOSPushService.php');

// Put your device token here (without spaces):
//$deviceToken = '0f744707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bbad78';
//perry's iphone: bbc3ea3a 889b43a6 c33aad83 aebd86d5 a6913472 9dec4fc5 e64e6f31 ebcf2076

// this device token is from the iphone.
// iphone app send it to api server and server store it in db
// then we get it from db and user it here.
$deviceToken = 'bbc3ea3a889b43a6c33aad83aebd86d5a69134729dec4fc5e64e6f31ebcf2076';

// Put your alert message here:
$message = 'Updated - CPSE push notification test!';

// this passphrase should be located in config file.
$passphrase = '12qw!@QW';

$service = new IOSPushService($passphrase);
$r = $service->pushNotice($deviceToken, $message);

if (!$r){
	echo 'Message not delivered' . PHP_EOL;
	throw new Exception('Message not delivered.');
}
else{
	echo 'Message successfully delivered' . PHP_EOL;
}


?>