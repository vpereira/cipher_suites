require 'active_record'
require 'csv'

ActiveRecord::Base.logger = Logger.new(STDERR)
 
ActiveRecord::Base.establish_connection(
:adapter => "sqlite3",
:database => ":memory:"
)

ActiveRecord::Schema.define do
    create_table :ciphers do |table|
        table.column :cipher_id, :string
        table.column :openssl, :string,:default=>"-"
        table.column :gnutls,  :string,:default=>"-"
        table.column :standard, :string,:default=>"-"
    end
end

class Cipher < ActiveRecord::Base
    def self.to_csv
         CSV.open("cipherlist_db.csv", "wb",:write_headers=>true,
                  :headers=>%w/cipher_id openssl gnutls standard/) do |output_file|
                        self.select(:cipher_id,:openssl,:gnutls,:standard).each do |row| 
                            output_file << [row.cipher_id, row.openssl, row.gnutls, row.standard] 
                        end
         end
    end
end

["gnutls.csv","openssl.csv","standard.csv"].each do |file|
    field_name = file.split(".").first
    CSV.foreach(file) do |r| 
        cipher = Cipher.find_or_create_by(:cipher_id=>r[0])
        cipher.send("#{field_name}=".to_sym,r[1]) unless r[1].blank?
        cipher.save
    end
end

Cipher.to_csv
