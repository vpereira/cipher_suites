#!/usr/bin/env ruby
require 'csv'

def print_help
    puts "params: gnutls_to_openssl|openssl_to_gnutls"
    puts "i.e: ./get_cipher gnutls_to_openssl"
    exit 1
end


def print_gnutls_to_openssl
    keys_to_search = []
    STDIN.each_line do |cipher_line|
        name, id_1, id_2, protocol = cipher_line.split
        keys_to_search << "#{id_1}#{id_2}" if id_1 =~ /^0x/
    end
    search_csv("gnutls_to_openssl",keys_to_search)
end
 
def print_openssl_to_gnutls
    keys_to_search = [] 
    STDIN.each_line do |cipher_line|
        keys_to_search = cipher_line.split(':').collect
    end
    search_csv("openssl_to_gnutls",keys_to_search)
end

def search_csv(mode = "gnutls_to_openssl",keys_to_search = [])
    options = { :headers => :first_row }

    f1,f2,f3 = if mode == "gnutls_to_openssl"
                   ["cipher_id","gnutls","openssl"]
               else
                   ["openssl","openssl","gnutls"]
               end
    CSV.open( "cipherlist_db.csv", "r", options ) do |csv|
        csv.find_all do |row|
            if keys_to_search.include? row[f1]
                puts "#{row[f2]} -> #{row[f3]}"
            end
        end
    end
end

if $0 == __FILE__
    ARGV.each do |a|
        case a
        when "gnutls_to_openssl"
            print_gnutls_to_openssl
        when "openssl_to_gnutls"
            print_openssl_to_gnutls
        else
            print_help
        end
    end 

end
