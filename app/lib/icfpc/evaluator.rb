module ICFPC
	class Evaluator
		Operator = Struct.new(:method_name, :arity)

		OPERATORS = {
			'=' => Operator.new(:assign, arity: 2),
			'ap' => Operator.new(:apply, arity: 2)
		}

		def eval(str)
			str
		end

		def assign
			raise NotImplemented
		end

		def apply
			raise NotImplemented
		end
	end
end
