#!/bin/bash
#root:

ENV=$1
PREFIX=$2

if [[ ! -d modules/Storage/certs ]];
then
    mkdir modules/Storage/certs
fi

cd modules/Storage/certs
BlobList=$(az iot dps certificate list --dps-name dev-propel-dps --query "value[].name" -o tsv)

echo $BlobList

if [[ ! ${BlobList} ]];
then

    echo -e "\n Generating .key and .pem file...\n"

    openssl genrsa -out ${ENV}${PREFIX}_RootCACertificate.key 2048

    openssl req -x509 -new -nodes -key ${ENV}${PREFIX}_RootCACertificate.key -sha256 -days 3650 -out ${ENV}${PREFIX}_RootCACertificate.pem -subj "/C=US/ST=California/L=SanFrancisco/O=DevPropel/OU=IT/CN=${ENV}${PREFIX}_RootCACertificate"

    echo -e "\n key and pem file generated for RootCA \n"

    #CN : devpropel

    # primary : DevPropel_PrimaryRootCACertificate

    echo -e "\n Generating PrimaryRootCACertificate...\n"

    openssl genrsa -out ${ENV}${PREFIX}_PrimaryRootCACertificate.key 2048

    openssl req -new -key ${ENV}${PREFIX}_PrimaryRootCACertificate.key -out ${ENV}${PREFIX}_PrimaryRootCACertificate.csr -subj "/C=US/ST=California/L=SanFrancisco/O=DevPropel/OU=IT/CN=${ENV}${PREFIX}_RootCACertificate"

    openssl x509 -req -in ${ENV}${PREFIX}_PrimaryRootCACertificate.csr -CA ${ENV}${PREFIX}_RootCACertificate.pem -CAkey ${ENV}${PREFIX}_RootCACertificate.key -CAcreateserial -out ${ENV}${PREFIX}_PrimaryRootCACertificate.pem -days 3650 -sha256

    echo "Primary CSR file generated"

    #secondary : DevPropel_SecondaryRootCACertificate

    echo -e "\n Generating SecondaryRootCACertificate...\n"

    openssl genrsa -out ${ENV}${PREFIX}_SecondaryRootCACertificate.key 2048

    openssl req -new -key ${ENV}${PREFIX}_SecondaryRootCACertificate.key -out ${ENV}${PREFIX}_SecondaryRootCACertificate.csr -subj "/C=US/ST=California/L=SanFrancisco/O=DevPropel/OU=IT/CN=${ENV}${PREFIX}_RootCACertificate"

    openssl x509 -req -in ${ENV}${PREFIX}_SecondaryRootCACertificate.csr -CA ${ENV}${PREFIX}_RootCACertificate.pem -CAkey ${ENV}${PREFIX}_RootCACertificate.key -CAcreateserial -out ${ENV}${PREFIX}_SecondaryRootCACertificate.pem -days 3650 -sha256

    echo "Secondary CSR file generated"

    #root : 

    echo -e "\n Generating PFX File for RootCA..."

    openssl pkcs12 -inkey ${ENV}${PREFIX}_RootCACertificate.key -in ${ENV}${PREFIX}_RootCACertificate.pem -export -out ${ENV}${PREFIX}_RootCACertificate.pfx -password pass:devpropel#2024

    echo -e "\n PFX File generated for RootCA\n"

    #primary : 

    echo -e "\n Generating PFX File for PrimaryRootCA..."

    openssl pkcs12 -export -out ${ENV}${PREFIX}_PrimaryRootCACertificate.pfx -inkey ${ENV}${PREFIX}_PrimaryRootCACertificate.key -in ${ENV}${PREFIX}_PrimaryRootCACertificate.pem -certfile ${ENV}${PREFIX}_RootCACertificate.pem -password pass:devpropel#2024

    echo "PFX File generated for PrimaryRootCA"

    #second : 

    echo -e "\n Generating PFX File for SecondaryRootCA..."

    openssl pkcs12 -export -out ${ENV}${PREFIX}_SecondaryRootCACertificate.pfx -inkey ${ENV}${PREFIX}_SecondaryRootCACertificate.key -in ${ENV}${PREFIX}_SecondaryRootCACertificate.pem -certfile ${ENV}${PREFIX}_RootCACertificate.pem -password pass:devpropel#2024

    echo "PFX File generated for SecondaryRootCA"

    # devpropel#2024
else
    echo "Required Certificates are already exist"
fi