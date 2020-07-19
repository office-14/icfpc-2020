require 'set'

module ICFPC
	module Functions
		FUNCTION_NAMES = Set["add", "negate", "mod", "dem", "lt", "inc", "dec", "mul", "div", "eq", "pwr2", "car", "cdr", "cons", "isnil", "nil"]

		class << self
			def add x1, x2
				x1 + x2
			end

			def negate x1
				-x1
			end

			def lt x1, x2
				x1 < x2
			end

			def inc x1
				x1 += 1
			end

			def dec x1
				x1 -= 1
			end

			def mul x1, x2
				x1 * x2
			end

			def div x1, x2
				x1 / x2
			end

			def eq x1, x2
				x1 == x2
			end

			def pwr2 x1
				2 ** x1
			end

			def car x1
				x1[0]
			end

			def cdr x1
				x1[1..-1]
			end

			def cons x1, x2
				x1.unshift(x2)
			end

			def nil x1
				true
			end

			def isnil x1
				x1.nil?
			end

			def mod num
				return '00' if num.nil?
				res = ''
				if num.kind_of?(Array)
					res += '11'
					num.each_with_index do |num_element, index|
						res += mod num_element
						if index != num.count - 1
							res += '11'
						end
					end
					res += '00'
				else
					return '010' if num == 0
					if num >= 0
						res += '01'
					else
						res += '10'
					end
					num = num.abs
					log_num = Math.log(num, 2)
					next_int_of_log_num = log_num.to_i + 1
					
					if next_int_of_log_num % 4 > 0
						factor = next_int_of_log_num / 4 + 1
					else
						factor = next_int_of_log_num / 4
					end
					(1..factor).each do 
						res += '1'
					end
					res += '0'
					all_bits_count = 4*factor
					num_as_bit_string = num.to_s(2)
					(1..all_bits_count-num_as_bit_string.length).each do 
						res += '0'
					end
					res += num_as_bit_string
				end

				res
			end

			def dem num_as_bit_string
				res, rest = dem_next(num_as_bit_string)
				raise "can't demodulate rest #{rest}" if rest.size > 0
				
				res
			end

			private

			def dem_next(bit_string)
				case bit_string[0..1]
				when "00"
					return [nil, bit_string[2..]]
				when "01", "10"
					return dem_number(bit_string)
				when "11"
					result = []
					rest = bit_string
					loop do
						rest, elem, finished = dem_list_item(rest)
						break if finished
						result << elem
					end
					
					return [result, rest]
				end
			end

			def dem_number(bit_string)
				sign = nil
				case bit_string[0..1]
				when "01"
					sign = 1
				when "10"
					sign = -1
				else
					raise "bad number sign #{bit_string}"
				end

				number_width = 0
				cur_index = 2
				while bit_string[cur_index] == '1'
					number_width += 1
					cur_index += 1
				end

				raise "bad number width" unless bit_string[cur_index] == '0'

				num = 0
				if number_width > 0
					num = bit_string[cur_index + 1, number_width * 4].to_i(2)
				end

				return [sign * num, bit_string[(cur_index + 1 + number_width * 4)..]]
			end

			def dem_list_item(bit_string)
				finished = false
				elem = nil
				rest = nil
				case bit_string[0..1]
				when "00"
					finished = true
					rest = bit_string[2..]
				when "11"
					elem, rest = dem_next(bit_string[2..])
				else
					raise "bad array item #{bit_string}"
				end

				[rest, elem, finished]
			end
		end
	end
end
