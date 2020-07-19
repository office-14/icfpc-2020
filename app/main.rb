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

    return demodulated_response
  else
    puts "Unexpected server response:"
    puts "HTTP code: %s" % res.code
    puts "Response body: %s" % res.body
    exit(2)
  end

  return false
end

def main
  begin
    serverurl = ARGV[0]
    playerkey = ARGV[1]
    post_paramenters = [2, playerkey.to_i, nil]
    answer = send serverurl, post_paramenters, playerkey, '/aliens/send'
    if answer != false
      if answer.count == 4
        post_paramenters = [3, playerkey.to_i, answer]
        answer = send serverurl, post_paramenters, playerkey, '/aliens/send'
      end
    end

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
