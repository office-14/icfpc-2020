require 'icfpc/evaluator'
require 'icfpc/tokenizer'

describe "simple" do
	subject {
		evaluator = ICFPC::Evaluator.new
	}

	it "first" do
		expect(subject.eval('ap ap add 3 5')).to eq 8
	end
end
