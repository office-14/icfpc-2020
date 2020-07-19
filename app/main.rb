$:.unshift File.join(__dir__, 'lib')

require 'net/http'
require 'icfpc/functions'

def send serverurl, post_paramenters, playerkey, api_query
  uri = URI(serverurl+api_query)
  puts "ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [serverurl+api_query, playerkey, post_paramenters]

  res = Net::HTTP.post(uri, ICFPC::Functions.mod(post_paramenters))
  if res.code == "200"
    demodulated_response = ICFPC::Functions.dem(res.body)
    if demodulated_response != [0]
      puts "Server response: %s" % demodulated_response.to_s
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
    answer = send serverurl, post_paramenters, playerkey, '/aliens/send'
    if answer != false 
      a = answer[2][0]
      b = answer[2][1]
      c = answer[2][2][0]
      d = answer[2][2][1]
      e = answer[2][2][2]
      f = answer[2][3][0]
      g = answer[2][3][1]
      h = 0
      i = 1
      permutations = []
      [a,b,c,d,e,f,g,h,i].permutation.to_a.each do |perm|
        permutations.push perm[0..3]
      end
      permutations = permutations.uniq
      permutations.push [1,1,1,1]
      permutations.each do |_perm|
        post_paramenters = [3, playerkey.to_i, _perm]
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
