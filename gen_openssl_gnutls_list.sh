#!/bin/bash
openssl ciphers  -V 'ALL@STRENGTH' | awk '{ print "\""$1"\""","$3 }' > openssl.csv
gnutls-cli --list | grep '^TLS_' | sed 's/\s\s*/ /g'  | awk '{ print "\""$2$3"\""","$1 }' > gnutls.csv
#TODO
#check if the file exists locally
#wget default names (as it is in the standars
if [ ! -e tls-parameters-4.csv ]; then
    wget https://www.iana.org/assignments/tls-parameters/tls-parameters-4.csv
fi
csvprintf -i -f tls-parameters-4.csv '"%1$s",%2$s\n' > tls-parameters_temp.csv

grep '^\"0x' tls-parameters_temp.csv  > standard.csv
rm -f tls-parameters_temp.csv
rm -f tls-parameters-4.csv
#
#http://backreference.org/2009/11/18/openssl-vs-gnutls-cipher-names/
