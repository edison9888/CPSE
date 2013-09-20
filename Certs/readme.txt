certs and keys in CPSE_CERTS/

how those files generated:

Certificates.p12 is private key generated in local machine.

Convert the .cer file into a .pem file:
Jis-MacBook-Air:CPSE_CERTS jimji2008$ openssl x509 -in aps_development.cer -inform der -out cpse_dev_cert.pem


Convert the private key’s .p12 file into a .pem file:
Jis-MacBook-Air:CPSE_CERTS jimji2008$ openssl pkcs12 -nocerts -out cpse_key.pem -in Certificates.p12 

Finally, combine the certificate and key into a single .pem file:
Jis-MacBook-Air:CPSE_CERTS jimji2008$ cat cpse_dev_cert.pem cpse_key.pem > ck_dev.pem

p: 12qw!@QW


ref: http://www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1