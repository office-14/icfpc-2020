$:.unshift File.join(__dir__, 'lib')

require 'net/http'
require 'icfpc/functions'

def send serverurl, post_paramenters
  uri = URI(serverurl)

  modulated_params = ICFPC::Functions.mod(post_paramenters)
  res = Net::HTTP.post(uri, modulated_params)
  if res.code == "200"
    demodulated_response = ICFPC::Functions.dem(res.body)
    puts "Server response: %s" % demodulated_response.to_s
  else
    puts "Unexpected server response:"
    puts "HTTP code: %s" % res.code
    puts "Response body: %s" % res.body
    exit(2)
  end
end

def main
  begin
    serverurl = ARGV[0]
    playerkey = ARGV[1]
    post_paramenters = [2, playerkey.to_i, nil]
    puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl, playerkey, post_paramenters]
    send serverurl, post_paramenters

    post_paramenters = [2, playerkey.to_i, [1]]
    puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl, playerkey, post_paramenters]
    send serverurl, post_paramenters

    post_paramenters = [2, playerkey.to_i, [2]]
    puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl, playerkey, post_paramenters]
    send serverurl, post_paramenters

    post_paramenters = [2, playerkey.to_i, [3]]
    puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl, playerkey, post_paramenters]
    send serverurl, post_paramenters

    post_paramenters = [2, playerkey.to_i, [4]]
    puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl, playerkey, post_paramenters]
    send serverurl, post_paramenters

    post_paramenters = [2, playerkey.to_i, [5]]
    puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl, playerkey, post_paramenters]
    send serverurl, post_paramenters
  rescue StandardError => e
    puts "Unexpected server response:"
    puts e
    puts e.backtrace
    exit(1)
  end
end

if __FILE__ == $0
  main
end
