require "minitest/autorun"
require File.expand_path '../test_helper.rb', __FILE__

describe RubyInstagramScraper do

  describe "calls with a user" do

    before do
      @username = "borodanov"
    end

    describe "#get_feed" do
      it "feed.user must be an array" do
        VCR.use_cassette(@username) do
          res = RubyInstagramScraper.get_feed(@username)
          res["user"]["username"].must_equal @username
          res["user"]["media"]["nodes"].must_be_instance_of Array
        end
      end
    end

    describe "when search" do
      it "users must be an array" do
        VCR.use_cassette("search") do
          RubyInstagramScraper.search(@username)["users"].must_be_instance_of Array
        end
      end
    end

    describe "#get_user" do
      it "must be an array" do
        VCR.use_cassette(@username) do
          RubyInstagramScraper.get_user_media_nodes(@username).must_be_instance_of Array
        end
      end
    end

    describe "when request user media nodes" do
      it "must be an array" do
        VCR.use_cassette(@username) do
          RubyInstagramScraper.get_user_media_nodes(@username).must_be_instance_of Array
        end
      end
    end

  end

  describe "when request tag media nodes" do
    before do
      @tag = "academgorodok"
    end

    it "must be an array" do
      VCR.use_cassette(@tag) do
        RubyInstagramScraper.get_tag_media_nodes(@tag).must_be_instance_of Array
      end
    end
  end

  describe "when request a media" do
    before do
      @code = "vKQeMNu7H1"
    end

    it "must has equal code in field" do
      VCR.use_cassette(@code) do
        RubyInstagramScraper.get_media(@code)["code"].must_equal @code
      end
    end
  end

end