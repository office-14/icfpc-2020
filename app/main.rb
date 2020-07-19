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
    if answer != false 
      permutations = []
      permutations.push([1,1,1,1])
      permutations.push([1,1,1,2])
      permutations.push([1,1,1,3])
      permutations.push([1,1,1,4])
      permutations.push([1,1,1,5])
      permutations.push([1,1,1,6])
      permutations.push([1,1,1,7])
      # [a,b,c,d,e,f,g,h,i].permutation.to_a.each do |perm|
      #   permutations.push perm[0..3]
      # end
      index= 0
      permutations.each do |_perm|
        index += 1
        post_paramenters = [2, playerkey.to_i, [index]]
        send serverurl, post_paramenters, playerkey, '/aliens/send'
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
