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
    Time.stub :now, Time.mktime(2015, 6, 1) do
      get "/"
      last_response.body.must_include "Nathan"
    end
  end

  it "ensures everybody gets a turn" do
    people = ["Nathan", "Toon", "Bob", "Piet", "Sophie", "Gregory", "Bram", "Lewis", "Koen", "Maarten", "Tom"]
    people.each.with_index do |p, i|
      Time.stub :now, (Time.mktime(2015, 6, 1) + i*60*60*24*7) do
        get "/"
        last_response.body.must_include "is: #{p}"
      end
    end
  end

  it "responds with json when asked" do
    get "/", {}, { "CONTENT_TYPE" => "application/json" }
    JSON.parse(last_response.body)["current"].wont_be_nil
  end

  it "returns the upcoming people as well" do
    get "/", {}, { "CONTENT_TYPE" => "application/json" }
    JSON.parse(last_response.body)["next"][0]["name"].wont_be_nil
  end
end
