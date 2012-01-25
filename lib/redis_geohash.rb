module RedisGeohash; end
require "redis_geohash/geohash"

class Range

  def avg
    (min+max)/2.0
  end

end
