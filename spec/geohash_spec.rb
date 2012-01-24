require ::File.expand_path('../../lib/redis_geohash', __FILE__)

describe RedisGeohash::Geohash do

  describe "adjacent buckets" do
    it "should find adjacent buckets"
  end

  describe "hash en/decoding" do

    describe "decoding" do

          
      it "should translate a string with the correct dictionary" do
        gh = RedisGeohash::Geohash.new
        gh.send(:dict_translate_string, "ezs42").should == [13, 31, 24, 4, 2]
      end

      it "should convert the binary to decimal"

    end

    describe "encoding" do

      it "should translate binary data with the correct dictionary" do
        gh = RedisGeohash::Geohash.new
        gh.send(:dict_translate_binary, [13, 31, 24, 4, 2]).should == "ezs42"
      end

      it "should convert the decimal to binary"

    end

    describe "example: cologne" do

      it "should calculate the correct hash for cologne :)" do
        gh = RedisGeohash::Geohash.new(:lat => 50.958087, :lng => 6.920449)
        gh.geohash.should == "u1hcvkxk65v5"
      end

      it "should calculate the correct hash for cologne with precision" do
        gh = RedisGeohash::Geohash.new(:lat => 50.958087, :lng => 6.920449)
        gh.geohash(5).should == "u1hcv"
        gh.geohash(8).should == "u1hcvkxk"
        gh.geohash(3).should == "u1h"
      end

    end

  end


end
