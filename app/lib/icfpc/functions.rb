require 'set'
require 'net/http'
require_relative './tree_node'

module ICFPC
  class CommonMeta < Struct.new(:bit_string)
  end

  class DemodulateArrayMeta < Struct.new(:depth, :bit_string, :closed)
    def initialize(depth, bit_string, closed = false)
      super
    end
  end

  class Cons
    attr_accessor :elements

    def initialize(elements)
      @elements = elements
    end
  end

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

      def send_to_alien(msg, debug = true)
        api_key = ENV["API_KEY"]

        abort 'No api key!!!' unless api_key
        url = "https://icfpc2020-api.testkontur.ru/aliens/send?apiKey=%s" % api_key

        msg_to_send = mod(msg)
        puts "-> #{msg_to_send}" if debug
        resp = Net::HTTP.post(URI(url), msg_to_send)
        puts "<- #{resp.body}" if debug

        if resp.code =~ /^3/
          puts "redirect target: %s" % resp["location"]
          raise "redirected"
        elsif resp.code != '200'
          pp [resp, resp.each_header.to_a]
          raise "error"
        end

        dem(resp.body)
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
        elsif num.kind_of?(Cons)
          res += '11'
          num.elements.each do |num_element|
            res += mod num_element
          end
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

      def dem(bit_string)
        parsed_tree, rest = dem_to_tree(bit_string)
        raise "can't demodulate rest #{rest}" if rest.size > 0
        dem_tree_to_data(parsed_tree)
      rescue
        raise "Got error when demodulating: #{$!.inspect}. For #{bit_string}"
      end

      def dem_to_tree(bit_string, parent = nil, no_comma: false)
        # pp ['tick', bit_string, parent]
        return [parent.get_root, ""] if bit_string.empty?

        case bit_string[0..1]
        when "00"
          if parent.nil? or no_comma
            # pp ['create nil value']
            new_node = TreeNode.new(nil, parent: parent, meta: CommonMeta.new(bit_string))
            dem_to_tree(bit_string[2..], parent || new_node)
          else
            if parent&.value.kind_of?(Array) && !parent.meta.closed
              if parent.meta.depth == 1 and bit_string.size > 2
                # pp ['set nil', bit_string, parent]
                # need backtrace for [nil]
                cur_node = parent

                if cur_node.children.size > 0 && !cur_node.children.last.value.kind_of?(Array)
                  while !cur_node.children.last.value.kind_of?(Array)
                    cur_node.children.pop
                  end

                  if cur_node.children.last.value.kind_of?(Array)
                    cur_node.children.last.meta.closed = false
                    dem_to_tree(cur_node.children.last.meta.bit_string, cur_node.children.last, no_comma: true)
                  else
                    raise 'unknown backtrace case'
                  end
                else
                  while cur_node.children.size > 0 && cur_node.children.last.value.kind_of?(Array)
                    cur_node = cur_node.children.last
                  end

                  new_node = TreeNode.new(nil, parent: cur_node, meta: CommonMeta.new(bit_string))
                  dem_to_tree(bit_string[2..], parent)
                end
              else
                # pp ['closing']
                parent.meta.closed = true
                node_to_return = if parent.parent.nil?
                  parent
                else
                  parent.parent
                end
                dem_to_tree(bit_string[2..], node_to_return)
              end
            else
              raise "unknown case for closing array/backtracing"
            end
          end
        when "01", "10"
          num, rest = dem_number(bit_string)
          new_node = TreeNode.new(num, parent: parent, meta: CommonMeta.new(bit_string))
          dem_to_tree(rest, parent || new_node)
        when "11"
          if !no_comma && parent && parent.children&.size > 0
            # it's comma
            # puts "comma"
            dem_to_tree(bit_string[2..], parent, no_comma: true)
          else
            # open array
            # puts "create array"
            depth = parent&.meta&.depth
            if depth
              depth += 1
            else
              depth = 1
            end
            dem_to_tree(bit_string[2..], TreeNode.new([], parent: parent, meta: DemodulateArrayMeta.new(depth, bit_string)))
          end
        end
      end

      def dem_tree_to_data(parsed_tree)
        if parsed_tree.value.kind_of? Array
          parsed_tree.children.map { |i| dem_tree_to_data(i) }.tap do |ch|
            if parsed_tree.meta.closed == false
              puts "bad bracers balance for #{ch.inspect}"
            end
          end
        else
          parsed_tree.value
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
    end
  end
end
