class RedisGeohash::Geohash

  DICTIONARY = "0123456789bcdefghjkmnpqrstuvwxyz"

  def initialize(opts={})

  end

private

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
      arr.map do |n|
        ("00000"+n.to_s(2))[-5..-1]
      end.join("").each_char.each_with_index do |c,i|
        out[i%2] << c.to_i
      end
    end
  end

end