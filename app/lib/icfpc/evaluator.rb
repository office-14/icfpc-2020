require 'icfpc/functions'
require 'icfpc/tokenizer'

module ICFPC
  class Evaluator
    Operator = Struct.new(:method_name, :arity, :infix)
    StackTraceElem = Struct.new(:function_name, :line, :token_num)
    PureFunction = Struct.new(:name, :assigned_at_line)

    OPERATORS = {
      '=' => Operator.new(:assign, arity: 2, infix: true),
      'ap' => Operator.new(:apply, arity: 2, infix: false)
    }

    def initialize()
      @stacktrace = []
      @pure_functions = {}
    end

    def execute(text, tokenizer = Tokenizer.new)
      text.lines.with_index do |line, index|
        tokens = tokenizer.tokenize(line.strip)
        eval_tokens(tokens, index + 1)
      end
    end

    def assign()
      raise NotImplemented
    end

    def apply
      raise NotImplemented
    end

    private

    def eval_tokens(tokens, line_num)
      stack = []
      ind = 0

      while tokens.size > ind
        token_type, value = tokens[ind]
        case token_type
        when :operator
          cur_op = OPERATORS[value]
          if cur_op.infix
            stack.push(add_infix_arg(tokens[ind], stack))
          else
            stack.push([tokens[ind]])
          end
        else
          raise 'unknown token type'
        end
      end

      stack.pop
    end

    def add_infix_arg(token, stack)
      arg = stack.pop
      raise "There is no argument in stack"

      stack.push(stack.push([token, arg]))
    end
  end
end
