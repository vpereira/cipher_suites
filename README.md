tool to map the cipher suite from different tools.

tools included here:

* cipher_translate.rb - tool to translate the cipher names from openssl to gnutls and vice versa. You are able as well to translate 
the output from get_ciphers.rb to gnutls

* get_ciphers.rb  - tool to map remotely which ciphers a remote server is supporting

* parse_gnutls.rb - parse the output from `gnutls -l`

* parse_openssl.rb  - parse the output from `openssl ciphers -V`

* ssl_cipher.rb - generates the csv mapping between gnutls, openssl and standard (as defined in the RFC)



for now we are supporting openssl, gnutls and standard (cipher name as defined in the RFC)

if you dont want to run the tool you can simply download the file cipherlist_db.csv
