require 'icfpc/functions'

describe ICFPC::Functions do
  describe "modulate" do
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

  describe "modulate non integers" do
    it "nil" do
      expect(subject.mod(nil)).to eq "00"
    end

    it "(1,2)" do
      expect(subject.mod([1,2])).to eq "1101100001110110001000"
    end

    it "(1,(2,3),4)" do
      expect(subject.mod([1,[2,3],4])).to eq "1101100001111101100010110110001100110110010000"
    end
  end

  describe "demodulate" do
    it "0" do
      expect(subject.dem("010")).to eq 0
    end

    it "1" do
      expect(subject.dem("01100001")).to eq 1
    end

    it "-1" do
      expect(subject.dem("10100001")).to eq(-1)
    end

    it "2" do
      expect(subject.dem("01100010")).to eq 2
    end

    it "-2" do
      expect(subject.dem("10100010")).to eq(-2)
    end

    it "16" do
      expect(subject.dem("0111000010000")).to eq 16
    end

    it "-16" do
      expect(subject.dem("1011000010000")).to eq(-16)
    end

    it "255" do
      expect(subject.dem("0111011111111")).to eq 255
    end

    it "-255" do
      expect(subject.dem("1011011111111")).to eq(-255)
    end

    it "256" do
      expect(subject.dem("011110000100000000")).to eq 256
    end

    it "-256" do
      expect(subject.dem("101110000100000000")).to eq(-256)
    end
  end

  describe "demodulate non integers" do
    it "nil" do
      expect(subject.dem("00")).to eq nil
    end

    it "()" do
      expect(subject.dem("1100")).to eq []
    end

    it "(())" do
      expect(subject.dem("11110000")).to eq [[]]
    end


    it "(nil)" do
      expect(subject.dem("110000")).to eq [nil]
    end

    it "(nil, nil)" do
      expect(subject.dem("1100110000")).to eq [nil, nil]
    end

    it "((nil), ())" do
      expect(subject.dem("1111000011110000")).to eq [[nil], []]
    end

    it "(1,2)" do
      expect(subject.dem("1101100001110110001000")).to eq [1,2]
    end

    it "(1,(2,3),4)" do
      expect(subject.dem("1101100001111101100010110110001100110110010000")).to eq [1,[2,3],4]
    end
  end

  describe "demodulate additional" do
    it "26" do
      expect(subject.dem("0111000011010")).to eq 26
    end

    it "(nil, -4, -5)" do
      expect(subject.dem(
        "11001110100100111010010100"
      )).to match_array [nil, -4, -5]
    end

    it "((nil), nil)" do
      expect(subject.dem(
        "11110000110000"
      )).to eq [[nil],nil]
    end

    it "((), nil)" do
      expect(subject.dem(
        "111100110000"
      )).to eq [[], nil]
    end
  end

  describe "random tests" do
    it "numbers" do
      1_000.times do
        num = rand_bignum
        expect(subject.dem(subject.mod(num))).to eq num
      end
    end

    it "arrays" do
      1_000.times do
        arr = rand_array(nil, 3, 3, 2)
        expect(subject.dem(subject.mod(arr))).to eq(arr)
      end
    end
  end

  describe "modulate/demodulate" do
    it "nil at end list" do
      expect(subject.dem(subject.mod([-1, nil, nil]))).to match_array([-1, nil, nil])
    end

    it "[nil] at end list" do
      expect(subject.dem(subject.mod([-1, nil, [nil]]))).to match_array([-1, nil, [nil]])
    end

    it "[nil, [nil, nil], [[], nil]]" do
      expr = [nil, [nil, nil], [[], nil]]
      expect(subject.dem(subject.mod(expr))).to eq expr
    end
  end

  def rand_bignum(max = 1_000_000_000_000_000_000)
    rand(1..max) * [1, -1].sample
  end

  def rand_array(depth = nil, max_size = 10, max_depth = 3, max_num = 1_000_000_000_000_000_000)
    res = []
    size = rand(0..max_size)
    cur_depth = depth || rand(0..max_depth)

    variants = if cur_depth == 0
      [:nil, :num]
    else
      [:nil, :num, :arr]
    end

    size.times do
      case variants.sample
      when :nil
        res.push(nil)
      when :num
        res.push(rand_bignum(max_num))
      when :arr
        if cur_depth > 0
          res.push(rand_array(cur_depth - 1, max_size, max_depth, max_num))
        else

        end
      end
    end

    res
  end
end
