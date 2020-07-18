require 'icfpc/tokenizer'

describe ICFPC::Tokenizer do
	it "simple inc" do
		expect(subject.tokenize('ap ap add 3 5')).to match_array [[:operator, "ap"], [:operator, "ap"], [:function, :add], [:primitive, 3], [:primitive, 5]]
	end
end
