$:.unshift File.join(__dir__, 'lib')

require 'net/http'
require 'icfpc/functions'

def send serverurl, post_paramenters, playerkey, api_query
  uri = URI(serverurl+api_query)
  puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl+api_query, playerkey, post_paramenters]

  res = Net::HTTP.post(uri, ICFPC::Functions.mod(post_paramenters))
  if res.code == "200"
    demodulated_response = []
    begin
      demodulated_response = ICFPC::Functions.dem(res.body)
      if demodulated_response != [0]
        puts "Server response: %s" % demodulated_response.to_s
      end
    rescue
      puts "Demodulate error: %s" % res.body.to_s
    end

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
    post_paramenters = [2, playerkey.to_i, [1]]
    send serverurl, post_paramenters, playerkey, '/aliens/send'
    
    post_paramenters = [3, playerkey.to_i, [196,0,8,78]]
    start_answer = send serverurl, post_paramenters, playerkey, '/aliens/send'
    role = start_answer[2][1]
    if role.to_i == 1
      ship = 0
    else
      ship = 1
    end

    index = 0
    while true do
      # post_paramenters = [4, playerkey.to_i, [[2, ship, ICFPC::Cons.new([rand(0..100),rand(0..100)]), 1]]]
     
      post_paramenters = [4, playerkey.to_i, [[0, ship, ICFPC::Cons.new([rand(-1..1),rand(-1..1)])]]]
      if index == 4
        post_paramenters = [4, playerkey.to_i, [[3, ship, [90,0,0,38]]]]
      end
      
      send serverurl, post_paramenters, playerkey, '/aliens/send'
      index += 1
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
