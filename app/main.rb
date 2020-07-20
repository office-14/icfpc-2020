$:.unshift File.join(__dir__, 'lib')

require 'net/http'
require 'icfpc/functions'

API_PATH = '/aliens/send'

class StaticGameInfo
  def initialize(resp)
    raise "static game info is not array: #{resp.inspect}" unless resp.kind_of?(Array)

    @x0, @role, @x2, @x3, @x4 = resp
  end

  def role
    Integer(@role)
  end
  def x3
    @x3
  end
end

class GameState
  def initialize(resp)
    raise "game_state is not array: #{resp.inspect}" unless resp.kind_of?(Array)

    @game_tick, @x1, @ships_and_commands = resp
  end

  def ships_and_commands
    @ships_and_commands
  end
end

class GameResponse
  def initialize(resp)
    raise "game_response is not array: #{resp.inspect}" unless resp.kind_of?(Array)

    @success_raw, @game_stage_raw, @static_game_info_raw, @game_state_raw = resp
  end

  def success
    !@success_raw.zero?
  end

  def game_stage
    case @game_stage_raw
    when 0
      :not_started
    when 1
      :started
    when 2
      :finished
    else
      raise "unknown game stage: #{@game_stage_raw.inspect}"
    end
  end

  def static_game_info
    @static_game_info ||= StaticGameInfo.new(@static_game_info_raw)
  end

  def game_state
    @game_state ||= GameState.new(@game_state_raw)
  end
end

def send serverurl, post_paramenters, playerkey
  uri = URI(serverurl + API_PATH)
  puts "-> ServerUrl: %s; PlayerKey: %s; post_paramenters: %s" % [uri.to_s, playerkey, post_paramenters]

  res = Net::HTTP.post(uri, ICFPC::Functions.mod(post_paramenters))
  if res.code == "200"
    puts "<- raw: %s" % res.body
    demodulated_response = ICFPC::Functions.dem(res.body)

    puts "<- %s" % demodulated_response.inspect
    return demodulated_response
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
    post_paramenters = [2, playerkey.to_i, [1]]

    answer = send serverurl, post_paramenters, playerkey

    post_paramenters = [3, playerkey.to_i, [196, 0, 8, 78]]
    answer = send serverurl, post_paramenters, playerkey
    gr = GameResponse.new(answer)

    move_vectors = [ICFPC::Cons.new([1, 1]), ICFPC::Cons.new([1, -1])]

    step = 1
    ship_id = 1 - gr.static_game_info.role

#"x4":[0,0,0,1],"x5":0,"x6":128,"x7":2
#[1, [16, 128], [[[1, 0, [-29, -46, [-1, 2, [0, 1, 1, 1], 7, 64, 1], [[0, [1, -1]]], [[0, 1, [29, 46, [1, -2, [191, 0, 8, 64], 0, 64, 1], [[0, [-1, 1]]]]]]]]]]]

    while (gr.success && gr.game_stage == :started)
      puts "ships&commands #{gr.game_state.ships_and_commands}"
      commands = []
      gr.game_state.ships_and_commands.each do |ship|
        commands.push([0, ship[0][1], ICFPC::Cons.new([rand(-2..2), rand(-2..2)])])
        commands.push([3, ship[0][1], [90,0,0,34]]) if step % 2 == 0
        #commands.push([2, ship[0][1], gr.static_game_info.role, gr.static_game_info.x3])
      end

      post_paramenters = [4, playerkey.to_i, commands]
      answer = send serverurl, post_paramenters, playerkey
      gr = GameResponse.new(answer)
      #sleep 0.5
      step += 1
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
