require 'icfpc/evaluator'
require 'icfpc/functions'

module ICFPC
	class Tokenizer
		TYPES = [:primitive, :function, :pure_function, :operator]

		def tokenize(str)
			str.scan(/\S+/).map do |token|
				if Evaluator::OPERATORS.has_key?(token)
					[:operator, token]
				elsif Functions::FUNCTION_NAMES.include?(token)
					[:function, token.to_sym]
				else
					if token == 'nil'
						[:primitive, nil]
					else
						[:primitive, Integer(token)]
					end
				end
			end
		end
	end
end
