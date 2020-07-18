require 'icfpc/evaluator'
require 'icfpc/tokenizer'

describe "simple" do
	subject {
		evaluator = ICFPC::Evaluator.new
	}

	it "first" do
		expect(subject.eval('ap inc 5')).to eq 6
	end
end