require 'icfpc/functions'

describe ICFPC::Functions do
  it "0" do
    expect(subject.mod(0)).to eq "010"
  end

  it "1" do
    expect(subject.mod(1)).to eq "01100001"
  end

  it "-1" do
    expect(subject.mod(-1)).to eq "10100001"
  end

  it "2" do
    expect(subject.mod(2)).to eq "01100010"
  end

  it "-2" do
    expect(subject.mod(-2)).to eq "10100010"
  end

  it "16" do
    expect(subject.mod(16)).to eq "0111000010000"
  end

  it "-16" do
    expect(subject.mod(-16)).to eq "1011000010000"
  end

  it "255" do
    expect(subject.mod(255)).to eq "0111011111111"
  end

  it "-255" do
    expect(subject.mod(-255)).to eq "1011011111111"
  end

  it "256" do
    expect(subject.mod(256)).to eq "011110000100000000"
  end

  it "-256" do
    expect(subject.mod(-256)).to eq "101110000100000000"
  end
end
