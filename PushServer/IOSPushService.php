<?php

class IOSPushService {
	private $passphrase;
	private $pushServerUrl;
	private $certKeyFile;

	function __construct($_passphrease)
	{
		$this->passphrase = $_passphrease;
		$this->pushServerUrl = 'ssl://gateway.sandbox.push.apple.com:2195';
		$this->certKeyFile = 'ck_development.pem';
	}

    public function pushNotice($deviceToken,$message){
		$ctx = stream_context_create();
		stream_context_set_option($ctx, 'ssl', 'local_cert', $this->certKeyFile);
		stream_context_set_option($ctx, 'ssl', 'passphrase', $this->passphrase);

		// Open a connection to the APNS server
		$fp = stream_socket_client(
			$this->pushServerUrl, $err,
			$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

		if (!$fp)
			exit("Failed to connect: $err $errstr" . PHP_EOL);

		echo 'Connected to APNS' . PHP_EOL;

		// Create the payload body
		$body['aps'] = array(
			'alert' => $message,
			'sound' => 'default'
			);

		// Encode the payload as JSON
		$payload = json_encode($body);

		// Build the binary notification
		$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

		// Send it to the server
		$result = fwrite($fp, $msg, strlen($msg));
			
		// Close the connection to the server
		fclose($fp);

		if (!$result){
			return false;
		}
		else{
			return true;
		}
    }
};



?>