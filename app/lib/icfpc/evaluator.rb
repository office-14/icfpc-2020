require 'icfpc/functions'
require 'icfpc/tokenizer'

module ICFPC
  class Evaluator
    Node = Struct.new(:token, :parent, :left, :right)
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
      text.each_line.with_index do |line, index|
        tokens = tokenizer.tokenize(line.strip)
        parsed_tree = parse(tokens, index + 1)

        pp ['tree', parsed_tree]
      end
    end

    def assign()
      raise NotImplemented
    end

    def apply
      raise NotImplemented
    end

    private

    def parse(tokens, line_num)
      cur_node = nil

      tokens.each_with_index do |token, index|
        begin
          token_type, _ = token
          new_node = Node.new(token, cur_node, nil, nil)
          if cur_node.nil?
            cur_node = new_node
          elsif token_type == :operator
            add_as_child(cur_node, new_node)
            cur_node = new_node
          else
            add_as_child(cur_node, new_node)
            if cur_node.parent && !cur_node.right.nil?
              cur_node = cur_node.parent   
            end
          end
        rescue
          raise "Wrong expression at token ##{index + 1} tokens #{tokens.inspect} at line #{line_num}. Error: #{$!.inspect}"
        end
      end

      get_tree_parent(cur_node)
    end

    def add_as_child(parent_node, new_node)
      if parent_node.left.nil?
        parent_node.left = new_node
      elsif parent_node.right.nil?
        parent_node.right = new_node
      else
        raise "Can't add child"
      end
    end

    def get_tree_parent(node)
      cur_node = node
      while cur_node&.parent
        cur_node = cur_node.parent
      end

      cur_node
    end

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
