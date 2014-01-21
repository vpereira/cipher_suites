#!/usr/bin/env ruby
require 'csv'

class CipherTable
    def initialize(params = {})
        @csv = nil
        @csv_file = "cipherlist_db.csv"
    end

    def open_table
        if @csv.nil?
            CSV.table(@csv_file)
        else
            @csv
        end
    end

    def get_csv_column(column = :cipher_id)
        open_table.by_col[column]
    end

    def get_csv_row
        open_table.by_row
    end

    def get_csv_rows(rows = [])
        rows.collect { |r| get_csv_row[r] }
    end

    def find_entries(column = :cipher_id, keys_to_search = [])
        found_keys = keys_to_search.collect do |k|
            get_csv_column(column).index(k)
        end
        get_csv_rows(found_keys.compact)
    end

end


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
    CipherTable.new.find_entries(:cipher_id,keys_to_search).each do |r|
        puts "#{r[2]} -> #{r[1]}"
    end
end
 
def print_openssl_to_gnutls
    keys_to_search = [] 
    STDIN.each_line do |cipher_line|
        cipher_id = cipher_line.split('-')[0]
        cipher_id.gsub!(/\s+/,"")
        keys_to_search << cipher_id
    end
    CipherTable.new.find_entries(:cipher_id,keys_to_search).each do |r|
        puts "#{r[1]} -> #{r[2]}"
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
