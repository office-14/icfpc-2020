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

			def mod num
				return '010' if num == 0
				res = ''
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

				res
			end

			def dem num_as_bit_string
				return 0 if num_as_bit_string == '010'
				num_chars = num_as_bit_string.chars
				signal = num_chars.shift(2).join
				matched_string = num_chars.join.match(/1+0+(1[0-1]+)/)
				num_abs = matched_string[1].to_i(2)
				if signal == '10'
					num_abs = 0 - num_abs
				end
				num_abs
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
		end
	end
end
