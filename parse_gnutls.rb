#!/usr/bin/env ruby

STDIN.each_line do |cipher_line|
   cipher_name, cipher_id1, cipher_id2, rest_line = cipher_line.split(' ')
   puts "\"#{cipher_id1}#{cipher_id2}\",#{cipher_name}" if cipher_name =~ /^TLS_/
end

