$:.unshift File.join(__dir__, 'lib')

require 'net/http'
require 'icfpc/functions'

def send serverurl, post_paramenters, playerkey, api_query
  uri = URI(serverurl+api_query)
  puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl+api_query, playerkey, post_paramenters]

  res = Net::HTTP.post(uri, ICFPC::Functions.mod(post_paramenters))
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
    send serverurl, post_paramenters, playerkey, '/aliens/send'
    post_paramenters = [2, playerkey.to_i, [nil]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'

    post_paramenters = [2, playerkey.to_i, [0]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'

    post_paramenters = [2, playerkey.to_i, [0,1]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'

    post_paramenters = [2, playerkey.to_i, [0,1,2]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'

    post_paramenters = [2, playerkey.to_i, [0,1,2,3]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'

    post_paramenters = [2, playerkey.to_i, [0,1,2,3,4]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'

    post_paramenters = [2, playerkey.to_i, [0,1,2,3,4,5]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'
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
