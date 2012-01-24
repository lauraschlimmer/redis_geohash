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

end