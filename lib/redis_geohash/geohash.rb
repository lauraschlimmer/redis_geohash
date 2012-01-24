class RedisGeohash::Geohash

  DICTIONARY = "0123456789bcdefghjkmnpqrstuvwxyz".freeze

  def initialize(opts={})

  end

private

  def geohash_decode(str)
    bins = binary_demultiplex(dict_translate_string(str))
    {
      :lat => value_approximate(bins[1], (-90..90)),
      :lng => value_approximate(bins[0], (-180..180))
    }
  end

  def value_approximate(arr, approx)
    arr.each do |b|
      approx = (b==1) ? (approx.avg..approx.max) : (approx.min..approx.avg)
    end
    approx.avg       
  end

  def value_encode(val, approx)
    [].tap do |arr|
      12.times.map do
        arr.push(val > approx.avg ? 1 : 0)
        approx = (arr[-1]==1) ? (approx.avg..approx.max) : (approx.min..approx.avg)
      end
    end
  end

  def dict_translate_string(str)
    str.each_char.map{ |c| DICTIONARY.index(c) }
  end

  def dict_translate_binary(arr)
    arr.map{ |n| DICTIONARY[n] }.join("")
  end

  def binary_multiplex(arr1, arr2)

  end

  def binary_demultiplex(arr)
    [[],[]].tap do |out|
      bitstream = arr.map do |n|
        ("00000"+n.to_s(2))[-5..-1]
      end.join("").each_char
      bitstream.each_with_index do |c,i|
        out[i%2] << c.to_i
      end
    end
  end

end
