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
        elsif token == 'nil'
          [:primitive, nil]
        elsif token =~ /^\-?\d+$/
          [:primitive, Integer(token)]
        else
          [:pure_function, token]
        end
      end
    end
  end
end
