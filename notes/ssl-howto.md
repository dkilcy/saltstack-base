
## SSL Certificates and Key Management

1. [Install Required Packages](#install-required-packages-on-all-hosts)
2. [Create Root CA Certificate and Private Key](#create-root-ca-certificate-and-private-key)
3. [Create Self-Signed Certificate with Wildcard CN](#create-self-signed-certificate-with-wildcard-cn)
4. [How to View Certificates](#how-to-view-certificates)
5. [Adding Certificates to the OS Trust Store](#adding-certificates-to-the-os-trust-store)
6. [Create Certificate with Subject Alt Names](#create-certificate-with-subject-alt-names)
7. [Reset CA Trust Store](#reset-ca-trust-store)
7. [References](#references)


### Install Required Packages on all hosts

  ```bash
  yum install ca-certificates openssl
  ```
  
### Create Root CA Certificate and Private Key

Create a Root CA Certificate and self-sign it.

1. Create the CA private key:
```
openssl genrsa -out local.key 2048
```

2. Create the CA Certificate and sign it with the CA private key
```
openssl req -new -x509 \
 -extensions v3_ca \
 -key local.key \
 -out local.crt \
 -days 3650 \
 -subj "/C=US/ST=VA/L=Reston/O=Local/OU=Lab/CN=Superlab CA"
```
** This command will return no output**

#### Create Self-Signed Certificate with Wildcard CN

1. Create the private key:
```
openssl genrsa -out s3.key 2048
```

2. Create the Certificate Signing Request (CSR) using the private key.

In this example, this verifes all hosts in the `*.lab.local` domain
```
openssl req -new -key s3.key -out s3.csr \
  -subj "/C=US/ST=VA/L=Reston/O=Local/OU=Lab
  /CN=*.lab.local"
```

3. Create the Certificate using the CSR and sign it with the CA Certificate and CA Private Key. 
```
openssl x509 -req -in s3.csr \
 -CA local.crt \
 -CAkey local.key \
 -CAcreateserial \
 -out s3.crt \
 -days 3650 \
 -sha256
```

4. Create the PEM File from the Certificate and Private Key
```
cat s3.crt s3.key > s3.pem
```

### How to View Certificates

- `openssl req -text -noout -in s3.csr`
- `openssl x509 -text -noout -in s3.crt`
- `openssl s_client -showcerts -cert s3.crt -key s3.pem -connect app1.lab.local:8000`
- `rpm -Vv ca-certificates`


### Adding Certificates to the OS Trust Store

Not all applications use the trust store.

1. Create the /etc/pki/local directory on all hosts

  ```bash
  salt '*' cmd.run 'mkdir -p /etc/pki/local'
  ```
  
2. Copy the certificates to all the hosts

  ```bash
  salt-cp '*' * /etc/pki/local/
  ```
  
3. Set the appropriate permissions

  ```bash
  salt '*' cmd.run 'chmod 644 /etc/pki/local/*'
  ```
  
4. Add CA Root Certificate to Trust Store

  ```bash
  salt '*' cmd.run 'update-ca-trust force-enable'
  salt '*' cmd.run 'ln -s /etc/pki/local/local.crt /etc/pki/ca-trust/source/anchors/local.crt'
  salt '*' cmd.run 'update-ca-trust extract'
  ```

### Create Certificate with Subject Alt Names

Create an openssl-san.cnf file

In this example, s3.lab.local is the LB/Endpoint and app1 thru app5.lab.local are the S3 connectors.

```
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = Country Name (2 letter code)
countryName_default = US
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = VA
localityName = Locality Name (eg, city)
localityName_default = Reston
organizationalUnitName	= Organizational Unit Name (eg, section)
organizationalUnitName_default	= Local
commonName = S3 SAN
commonName_max	= 64

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = app1.lab.local
DNS.2 = app2.lab.local
DNS.3 = app3.lab.local
DNS.4 = app4.lab.local
DNS.5 = app5.lab.local
DNS.6 = s3.lab.local
```

1.Generate private key
  ```
openssl genrsa -out s3.key 2048
  ```

2. Create the CSR file

  ```
openssl req -new -out s3.csr -key s3.key -config openssl-san.cnf
  ```

3. Self-sign and create the certificate:

  ```
openssl x509 -req -days 3650 -in s3.csr -signkey s3.key \
 -out s3.crt -extensions v3_req -extfile openssl-san.cnf \
 -CA local.crt -CAkey local.key -CAcreateserial
  ```

4. Create the PEM file from the Certificate and Private Key

  ```
cat s3.crt s3.key > s3.pem
  ```

### Reset CA Trust Store

1. Move everything out of the Trust Store

  ```
  rpm -Vv ca-certificates
  ```

2. Re-install ca-certificates

  ```
  yum check-update ca-certificates; (($?==100)) && yum update ca-certificates || yum reinstall ca-certificates`
  ```
  
3. Reset the Trust Store

  ```
  update-ca-trust extract
  ```
  
### References

- http://apetec.com/support/GenerateSAN-CSR.htm
- https://www.sslshopper.com/article-most-common-openssl-commands.html
- https://superuser.com/questions/462295/openssl-ca-and-non-ca-certificate
- [How to reset the list of trusted CA certificates in RHEL 6 & RHEL 7 ](https://access.redhat.com/solutions/1549003)

