require 'icfpc/evaluator'
require 'icfpc/tokenizer'

describe "simple" do
  subject {
    ICFPC::Evaluator.new
  }

  it "simple add" do
    expect(subject.execute('ap ap add 3 5')).to eq 8
  end

  it "inc" do
    code = -"""
      inc = ap add 3
      ap inc 7
    """
    expect(subject.execute(code)).to eq 8
  end
end
