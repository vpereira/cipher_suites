#!/usr/bin/env ruby

STDIN.each_line do |cipher_line|
   cipher_id = cipher_line.split('-')[0]
   cipher_id.gsub!(/\s+/,"")
   cipher_name = cipher_line.split(/\s+/)[3]
   puts "\"#{cipher_id}\",#{cipher_name}"

end

