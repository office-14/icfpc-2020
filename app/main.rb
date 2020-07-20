$:.unshift File.join(__dir__, 'lib')

require 'net/http'
require 'icfpc/functions'

API_PATH = '/aliens/send'

class StaticGameInfo
  def initialize(resp)
    raise "static game info is not array: #{resp.inspect}" unless resp.kind_of?(Array)

    _, @role = resp
  end

  def role
    Integer(@role)
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

    post_paramenters = [3, playerkey.to_i, [1, 1, 1, 1]]
    answer = send serverurl, post_paramenters, playerkey
    gr = GameResponse.new(answer)

    move_vectors = [ICFPC::Cons.new([1, 1]), ICFPC::Cons.new([4, 4])]

    step = 1
    ship_id = if gr.static_game_info.role == 1
      0
    else
      1
    end
    while (gr.success && gr.game_stage == :started)
      post_paramenters = [4, playerkey.to_i, [0, ship_id, move_vectors.sample]]
      answer = send serverurl, post_paramenters, playerkey
      gr = GameResponse.new(answer)
      sleep 0.5
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
