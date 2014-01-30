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
    []
end


def translate_gnutls_to_openssl
    keys_to_search = []
    STDIN.each_line do |cipher_line|
        name, id_1, id_2, protocol = cipher_line.split
        keys_to_search << "#{id_1}#{id_2}" if id_1 =~ /^0x/
    end
    keys_to_search
end

def translate_openssl_to_gnutls
    keys_to_search = [] 
    STDIN.each_line do |cipher_line|
        cipher_id = cipher_line.split('-')[0]
        cipher_id.gsub!(/\s+/,"")
        keys_to_search << cipher_id
    end
    keys_to_search
end

def translate_get_cipher_to_gnutls
    keys_to_search = []
    STDIN.each_line do |cipher_line|
        cipher_name = cipher_line.split[2] #debug mode isnt supported
        keys_to_search << cipher_name if cipher_name
    end
    keys_to_search
end

if $0 == __FILE__
    mode = 0
    ARGV.each do |a|
        keys_to_search = case a
        when "gnutls_to_openssl"
            mode = 1
            translate_gnutls_to_openssl
        when "openssl_to_gnutls"
            mode = 2
            translate_openssl_to_gnutls
        when "get_cipher_to_gnutls"
            mode = 3
            translate_get_cipher_to_gnutls
        else
            print_help
        end
        if mode > 0
            if mode < 3
                CipherTable.new.find_entries(:cipher_id,keys_to_search).each do |r|
                    if mode == 1 
                        puts "#{r[2]} -> #{r[1]}"
                    else
                        puts "#{r[1]} -> #{r[2]}"
                    end
                end
            else
                CipherTable.new.find_entries(:openssl,keys_to_search).each do |r|
                    puts "#{r[1]} -> #{r[2]}"
                end
            end
        end
    end 
end
