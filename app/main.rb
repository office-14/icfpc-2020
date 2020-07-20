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

    variables_move = [
      [0,-1],
      [0,1],
      [1,0],
      [-1,0],
      [1,1],
      [-1,-1]
    ]
    wall_way = [[-1,1],[-1,-1]] 
    index = 0
    answer_action = []
    while true do
      # post_paramenters = [4, playerkey.to_i, [[2, ship, ICFPC::Cons.new([rand(0..100),rand(0..100)]), 1]]]
      
      if index == 0
        post_paramenters = [4, playerkey.to_i, [[3, ship, [90,0,0,38]]]]
      else
        move_rand1 = variables_move.sample(1)[0]
        move_rand2 = variables_move.sample(1)[0]
        move_rand3 = variables_move.sample(1)[0]
        move_rand4 = variables_move.sample(1)[0]

        
        commands = []
        if role.to_i == 1
          wall_way_move = wall_way[(index%2)]
          commands.push [0, ship, ICFPC::Cons.new(wall_way_move)]
        else
          begin
            shoot_x = answer_action[3][2][0][0][2][4][0][2][0]
            shoot_y = answer_action[3][2][0][0][2][4][0][2][1]
            if index == 1
              commands.push [2, ship, ICFPC::Cons.new([shoot_x-2,shoot_y-4]), 1]
            elsif index == 2
              commands.push [2, ship, ICFPC::Cons.new([shoot_x-2,shoot_y-4]), 0]
            elsif index == 3
              commands.push [2, ship, ICFPC::Cons.new([shoot_x-2,shoot_y-4]), 196]
            elsif index == 4
              commands.push [2, ship, ICFPC::Cons.new([shoot_x-2,shoot_y-4]), 78]
            elsif index == 5
              commands.push [2, ship, ICFPC::Cons.new([shoot_x-2,shoot_y-4]), 38]
            end
          rescue
            commands.push [0, ship, ICFPC::Cons.new(variables_move.sample(1)[0])]
          end
        end
        commands.push [0, 1+1, ICFPC::Cons.new(move_rand1)]
        commands.push [0, 1+2, ICFPC::Cons.new(move_rand2)]
        commands.push [0, 1+3, ICFPC::Cons.new(move_rand3)]
        commands.push [0, 1+4, ICFPC::Cons.new(move_rand4)]

        post_paramenters = [4, playerkey.to_i, commands]
      end
      
      answer_action = send serverurl, post_paramenters, playerkey, '/aliens/send'
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
