=begin
<Set: {"=",
 "ap",
 "cons",
 "nil",
 "neg",
 "c",
 "b",
 "s",
 "isnil",
 "car",
 "eq",
 "mul",
 "add",
 "lt",
 "div",
 "i",
 "t",
 "cdr",
 "galaxy"}>
=end

galaxy_input = ARGF.read

output = ''
galaxy_input.lines.each do |line|
	processed = line.gsub(/(?:^|\s):(\d+)/) { |m| m.sub(/(\s*):/, "$1fun_") }
	output += processed
end

print output