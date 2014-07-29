1. openssl genrsa -des3 -out Keys/RootCA.key 2048
2. openssl req -config openssl.cfg -new -x509 -days 136000 -key Keys/RootCA.key -out Certificates/RootCA.crt
3. openssl ca -policy policy_anything -config openssl.cfg -cert Certificates/RootCA.crt -in CSR/CSR.txt -keyfile Keys/RootCA.key -days 136000 -out Certificates/SampleCert.crt

password: 111111