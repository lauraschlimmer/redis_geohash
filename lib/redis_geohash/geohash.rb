class RedisGeohash::Geohash

  DICTIONARY = "0123456789bcdefghjkmnpqrstuvwxyz".freeze

  def initialize(opts={})

  end

private

  # encode a decimal lat/lng pair to a geohash-string
  # the output of this function may slightly differ from machine to machine!
  def geohash_encode(lat, lng)
    dict_translate_binary(binary_multiplex(
      value_encode(lng, (-180..180)), 
      value_encode(lat, (-90..90))
    ))
  end

  # decode a geohash-string to a hash containing lat/lng as numbers
  # the output of this function may slightly differ from machine to machine!
  def geohash_decode(str)
    bins = binary_demultiplex(dict_translate_string(str))
    {
      :lat => value_approximate(bins[1], (-90..90)),
      :lng => value_approximate(bins[0], (-180..180))
    }
  end

  # translate a string char-wise to a array of bytes with the base32-like dictionary
  def dict_translate_string(str)
    str.each_char.map{ |c| DICTIONARY.index(c) }
  end

  # translate an array of bytes to a string with the base32-like dictionary
  def dict_translate_binary(arr)
    arr.map{ |n| DICTIONARY[n] }.join("")
  end

  # approximate the decimal value of a binary lat or lng representation
  # second parameter is (-90..90) for lat and (-180..180) for lng
  def value_approximate(arr, approx)
    return approx.avg if arr.length == 0
    if arr[0] == 1
      value_approximate(arr[1..-1], (approx.avg..approx.max))
    else
      value_approximate(arr[1..-1], (approx.min..approx.avg))
    end   
  end

  # calculate a 12-bit binary representation of a decimal lat or lng value
  # second parameter is (-90..90) for lat and (-180..180) for lng
  def value_encode(val, approx, n=12)    
    return nil if n == 0      
    if val > approx.avg 
      [1, value_encode(val, (approx.avg..approx.max), n-1)]
    else
      [0, value_encode(val, (approx.min..approx.avg), n-1)]
    end.flatten.compact
  end

  # convert two binary representations of a lat + lng pair into one "bitstream"
  def binary_multiplex(arr1, arr2)
    bitstream = ""

    # merge the two "bitstreams". lng on the even- and lat on the odd-indexed bits
    (arr1.length+arr2.length).times do |i|
      bitstream += (i%2==0 ? arr1.shift : arr2.shift).to_s
    end

    # split the merged bitstream into five-bit pieces and return them as numbers
    (bitstream.length/5.0).ceil.times.map do |i|
      bitstream[i*5..((i+1)*5)-1].to_i(2)
    end
  end

  # convert a binary "bitstream" into the binary representations of lat/lng
  def binary_demultiplex(arr)
    [[],[]].tap do |out|

      # split the bitstream into groups of 5
      bitstream = arr.map do |n|
        ("00000"+n.to_s(2))[-5..-1]
      end.join("").each_char

      # unmerge the bitstream: lng-bits for even and lat-bits for odd positions
      bitstream.each_with_index do |c,i|
        out[i%2] << c.to_i
      end
    end
  end

end
