redis_geohash
=============

location-aware lists + simple distance calculation with geohashes and ruby/redis. geohash implementation in pure ruby.

[ ![Build status - Travis-ci](https://secure.travis-ci.org/paulasmuth/redis_geohash.png) ](http://travis-ci.org/paulasmuth/redis_geohash)

http://en.wikipedia.org/wiki/Geohash

---

### using redis_geohash

`RedisGeohash.connect!` is only necessary if you want to use LookupTables.


```ruby
require "redis"
require "redis_geohash"

my_redis = Redis.new
RedisGeohash.connect!(my_redis)
```
---

### location aware lists

Every `RedisGeohash::LookupTable` will create 8 redis-keys (hashes). Precision can be 0-8. Use `:no_reverse_lookup => true` to disable the second lookup pass (much faster, less acurate).

```ruby
# create a namespace
geo_tbl = RedisGeohash::LookupTable.new('my_world')

# store the first items
geo_tbl.store!(:id => '23422342', :lat => ..., :lng => ...)
geo_tbl.store!(:id => '55552323', :lat => ..., :lng => ...)

# do a radius/grid search
geo_tbl.lookup(:lat => ..., :lng => ..., :precision => 4)
# => ['23422342', '55552323', ...]

# do a fast radius/grid search
geo_tbl.lookup(:lat => ..., :lng => ..., :precision => 4, :no_reverse_lookup => true)
# => ['23422342', '55552323', ...]
```
---

### creating hashes manually

Hashes can be created without a redis connection

```ruby
# create from lat/lng
geo_hash = RedisGeohash::GeoHash.new(:lat => ..., :lng => ...)

# create from geohash string
geo_hash = RedisGeohash::GeoHash.new("u33dc1f0j1nqg")

geo_hash.geohash
# => "u33dc1f0j1nqg"

geo_hash.coordinates
# => {:lat => ..., :lng => ...}

geo_hash.adjacents
# => [<GeoHash geohash="...">, <GeoHash geohash="...">, ...]
```
---

### bonus: distance calculation

Pass in two lat/lng-hashes or two `RedisGeohash::GeoHash` objects.

```ruby
RedisGeohash.distance({:lat => ..., :lng => ...}, {:lat => ..., :lng => ...})
#  => 34,654

RedisGeohash.distance(geo_hash_one, geo_hash_two)
#  => 34,654
```


Installation
------------

    gem install redis_geohash

or in your Gemfile:

    gem 'redis_geohash', '~> 0.1'


Caveats
-------
+ There is currently no (atomic) way to remove ids from a table


Todos
-----
+ remove range monkeypatch


License
-------

Copyright (c) 2011 Paul Asmuth

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to use, copy and modify copies of the Software, subject 
to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
