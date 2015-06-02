# test_helper.rb
ENV["RACK_ENV"] = "test"
require "minitest/autorun"
require "minitest/pride"
require "rack/test"

require File.expand_path "./app"

include Rack::Test::Methods

def app
  Cleaner.app
end

describe "Cleaning duties" do
  it "sets the first one to the first day" do
    Time.stub :now, Time.mktime(2014, 11, 17) do
      get "/"
      last_response.body.must_include "Piet"
    end
  end

  it "ensures everybody gets a turn" do
    ["Piet", "Sophie", "Gregory", "Bram", "Lewis", "Koen", "Maarten", "Tom", "Nathan", "Bob"].each.with_index do |p, i|
      Time.stub :now, (Time.mktime(2014, 11, 17) + i*60*60*24*7) do
        get "/"
        last_response.body.must_include "p"
      end
    end
  end
end
