require 'rest-client'
require 'parallel'

OUTPUT_FILE="tmp/output.txt"
API_KEY=ENV["API_KEY"]
abort 'No api key!!!' unless API_KEY
URL="https://icfpc2020-api.testkontur.ru/aliens/send?apiKey=%s" % API_KEY

BULK_SIZE = 1000
THREADS = 80

def send_alien(req)
	RestClient.post(URL, req)
end

OUTPUT = File.open(OUTPUT_FILE, "a")
at_exit { OUTPUT.close }

def bulk_parse(start_int)
	Parallel.each(start_int.upto(start_int + BULK_SIZE - 1), in_threads: THREADS) do |val|
		binval = val.to_s(2)
		puts "-> %s" % val.to_s(2)
		resp = send_alien(binval)
		puts "<- %s" % resp.body
		if resp.body != "1101000"
			OUTPUT.flock(File::LOCK_EX)
			OUTPUT.write("%s -> %s\n" % [binval, resp.body])
			OUTPUT.flock(File::LOCK_UN)
		end
	end
end

cur_binary_str = ARGV.first

int_val = cur_binary_str.to_i(2)

loop do
	bulk_parse(int_val)

	int_val += BULK_SIZE
end
