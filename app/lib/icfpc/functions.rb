require 'set'

module ICFPC
	module Functions
		FUNCTION_NAMES = Set["add", "negate"]

		class << self
			def add x1, x2
				x1 + x2
			end

			def negate x1
				-x1
			end
		end
	end
end
