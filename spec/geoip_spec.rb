# -*- coding: utf-8 -*-
require 'spec_helper'
# require 'ruby-debug'
# Debugger.start


describe GeoIP do

  before do
    @ip = "24.24.24.24"
    @ipnum = 16777216*24 + 65536*24 + 256*24 + 24

    @large_ip = "245.245.245.245"
    @large_ipnum = 16777216*245 + 65536*245 + 256*245 + 245
  end

  it "should addr to num" do
    GeoIP.addr_to_num(@ip).should eql(@ipnum)
  end

  it "should converts large ips to an ipnum correctly" do
    GeoIP.addr_to_num(@large_ip).should eql(@large_ipnum)
  end

  it "should expects an ip string" do
    lambda { GeoIP.addr_to_num(nil) }.should raise_error TypeError
  end

  it "should returns zero for an illformed ip string" do
    GeoIP.addr_to_num("foo.bar").should be_zero
  end

  it "should converts an ipnum to an ip?" do
    GeoIP.num_to_addr(@ipnum).should eql(@ip)
  end

  it "should converts large ipnums to an ip correctly" do
    GeoIP.num_to_addr(@large_ipnum).should eql(@large_ip)
  end

  it "should num to addr expects a numeric ip" do
    lambda { GeoIP.num_to_addr(nil)}.should raise_error TypeError
    lambda { GeoIP.num_to_addr("foo.bar")}.should raise_error TypeError
  end

  describe "GeoIPCity" do

    before(:all) do
      fname = "GeoLiteCity.dat"
      dbfile = File.exists?(fname) ? fname : '/usr/local/GeoIP/share/GeoIP/GeoLiteCity.dat'
      @db = GeoIP::City.new(dbfile)
    end

    it "should type check" do
      lambda { @db.look_up(nil) }.should raise_error TypeError
    end

    it "should return a hash" do
      @db.look_up('24.24.24.24').should be_instance_of Hash
    end

    it "should be rochester" do
      @db.look_up('24.24.24.24')[:city].should eql("Rochester")
    end

    it "should be in the usa" do
      @db.look_up('24.24.24.24')[:country_name].should eql("United States")
    end

    it "should be utf8 friendly" do
      @db.look_up('201.16.240.1')[:city].should eql("Ribeirão Prêto")
    end

  end

  describe "GeoIPCity Constructors" do

    before(:all) do
      fname = "GeoLiteCity.dat"
      @dbfile = File.exists?(fname) ? fname : '/usr/local/GeoIP/share/GeoIP/GeoLiteCity.dat'
    end

    def match(db, addr, field, value)
      value.should eql(db.look_up(addr)[field])
    end

    it "should test index" do
      db = GeoIP::City.new(@dbfile, :index)
      match(db, '24.24.24.24', :city, 'Rochester')
    end

    it "should test filesystem" do
      db = GeoIP::City.new(@dbfile, :filesystem)
      match(db, '24.24.24.24', :city, 'Rochester')
    end

    it "should test filesystem" do
      db = GeoIP::City.new(@dbfile, :filesystem, true)
      match(db, '24.24.24.24', :city, 'Rochester')
    end

    it "should test memory" do
      db = GeoIP::City.new(@dbfile, :memory)
      match(db, '24.24.24.24', :city, 'Rochester')
    end

    it "should fail with bad db file" do
      lambda { GeoIP::City.new('/blah') }.should raise_error Errno::ENOENT
    end

  end

end


# IPORG = '/usr/local/GeoIP/share/GeoIP/GeoIPOrg.dat'

# if File.exists?(IPORG)
#   class GeoIPOrgTest < Test::Unit::TestCase

#     def setup
#       ## Change me!
#       @dbfile = '/usr/local/GeoIP/share/GeoIP/GeoIPOrg.dat'
#     end

#     def test_construction_default
#       db = GeoIP::Organization.new(@dbfile)

#       assert_raises TypeError do
#         db.look_up(nil)
#       end

#       h = db.look_up('24.24.24.24')
#       assert_kind_of Hash, h
#       assert_equal 'Road Runner', h[:name]
#     end

#     def test construction index
#       db = GeoIP::Organization.new(@dbfile, :index)
#       match(db, '24.24.24.24', :name, 'Road Runner')
#     end

#     def test construction filesystem
#       db = GeoIP::Organization.new(@dbfile, :filesystem)
#       match(db, '24.24.24.24', :name, 'Road Runner')
#     end

#     def test construction memory
#       db = GeoIP::Organization.new(@dbfile, :memory)
#       match(db, '24.24.24.24', :name, 'Road Runner')
#     end

#     def test construction filesystem check
#       db = GeoIP::Organization.new(@dbfile, :filesystem, true)
#       match(db, '24.24.24.24', :name, 'Road Runner')
#     end

#     def test bad db file
#       assert_raises Errno::ENOENT do
#         GeoIP::Organization.new('/blah')
#       end
#     end

#   end
# end
