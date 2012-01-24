require ::File.expand_path('../spec_helper', __FILE__)

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

      it "should de-mutiplex the binary data" do
        gh = RedisGeohash::Geohash.new
        gh.send(:binary_demultiplex, [13, 31, 24, 4, 2]).should == [
          [0,1,1,1,1,1,0,0,0,0,0,0,0],
          [1,0,1,1,1,1,0,0,1,0,0,1]
        ]
      end

      it "should approximate the value of a binary representation" do
        gh = RedisGeohash::Geohash.new
        val = gh.send(:value_approximate, [1,0,1,1,1,1,0,0,1,0,0,1], (-90..90))
        val.round(1).should == 42.6
      end

      it "should convert the hash (string) to lat/lng (1/2)" do
        gh = RedisGeohash::Geohash.new     
        val = gh.send(:geohash_decode, "ezs42")
        val[:lat].round(1).should == 42.6
        val[:lng].round(1).should == -5.6        
      end

      it "should convert the hash (string) to lat/lng (2/2)" do
        gh = RedisGeohash::Geohash.new         
        val = gh.send(:geohash_decode, "u1hcvkxk65v5")
        val[:lat].round(1).should == 51.0
        val[:lng].round(1).should == 6.9      
      end

    end

    describe "encoding" do

      it "should translate binary data with the correct dictionary" do
        gh = RedisGeohash::Geohash.new
        gh.send(:dict_translate_binary, [13, 31, 24, 4, 2]).should == "ezs42"
      end

      it "should multiplex the binary data streams (lat/lng)"

      it "should calculate the binary representation of a value" 

      it "should convert the decimal to binary"

    end

    describe "example: cologne" do

      it "should calculate the correct hash for cologne :)" do
        pending("todo!")
        gh = RedisGeohash::Geohash.new(:lat => 50.958087, :lng => 6.920449)
        gh.geohash.should == "u1hcvkxk65v5"
      end

      it "should calculate the correct hash for cologne with precision" do
        pending("todo!")
        gh = RedisGeohash::Geohash.new(:lat => 50.958087, :lng => 6.920449)
        gh.geohash(5).should == "u1hcv"
        gh.geohash(8).should == "u1hcvkxk"
        gh.geohash(3).should == "u1h"
      end

    end

  end


end
