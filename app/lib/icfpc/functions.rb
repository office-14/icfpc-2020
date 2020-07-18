require 'set'

module ICFPC
    module Functions
        FUNCTION_NAMES = Set["add"]

        class << self
            def add x1, x2
                x1 + x2
            end
        end
    end
end
