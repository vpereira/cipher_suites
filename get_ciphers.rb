require 'openssl'
require 'socket'
require 'timeout'
require 'trollop'

opts = Trollop::options do
    banner <<-EOS
        usage:
        #{$0} [options]
        Where options are:
    EOS
    opt :tlsv1, "TLSv1", :default=>false
    opt :tlsv12,"TLSv1.2", :default=>false
    opt :sslv2,"SSLv2", :default=>false
    opt :sslv3,"SSLv3", :default=>false
    opt :host, "hostname", :type=>:string
    opt :port, "port", :type=>:int
end


Trollop::die :host, "you must choose a host" unless opts[:host]
Trollop::die :port, "you must choose a port" unless opts[:port]


protocol = if opts[:tlsv1]
               :TLSv1
           elsif opts[:tlsv12]
               :TLSv12
           elsif opts[:sslv2]
               :SSLv2
           elsif opts[:sslv3]
               :SSLv3
           else
               :SSLv23
           end

OpenSSL::SSL::SSLContext.new(protocol).ciphers.each do |cipher_name, cipher_version, bits, algorithm_bits| 
    context = OpenSSL::SSL::SSLContext::new #TODO TLSv1, SSLV23, etc
    context.ciphers = [cipher_name]
    tcp_socket = TCPSocket.new opts[:host], opts[:port]
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_socket, context
    begin
        Timeout::timeout(2) do
            ssl_client.connect
        end
    rescue OpenSSL::SSL::SSLError => e
        puts "[-] Rejected\t #{cipher_name}\t #{cipher_version}"
    rescue Timeout::Error => f
        puts "[x] Timeout\t  #{cipher_name}\t #{cipher_version}"
    rescue #Ignore all other Exceptions
    else
        puts "[+] Accepted\t #{cipher_name}\t #{cipher_version}"
    ensure
        ssl_client.close
    end
end
