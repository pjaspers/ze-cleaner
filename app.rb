require "rack"
require "rack-cache"
require "shack"
require "json"

module Cleaner
  def self.app
    Rack::Builder.new do
      # use Rack::Cache,
      # :verbose     => true,
      # :metastore   => 'file:/tmp/rack/cache/meta',
      # :entitystore => 'file:/tmp/rack/cache/body'
      use Rack::ContentLength
      use Rack::ContentType
      use Shack::Middleware, "dinges"
      run -> (env) {
        current_time = Time.now

        midnight = Time.mktime(current_time.year, current_time.month, current_time.day, 23, 59, 59)
        the_list = ["Nathan", "Toon", "Bob", "Piet", "Sophie", "Gregory", "Bram", "Lewis", "Koen", "Maarten", "Tom"]
        the_day_it_all_began = Time.mktime(2015, 6, 1)

        one_week = 60 * 60 * 24 * 7
        # Number of weeks % number of people = the week we're in.
        week_number = (((midnight - the_day_it_all_began) / one_week) % the_list.count).floor
        cleaner = the_list[week_number]
        next_up = the_list[the_list.index(cleaner)..-1] + the_list[0...the_list.index(cleaner)]
        if env["CONTENT_TYPE"] == "application/json"
          json = { current: {name: next_up.shift},
                   next: next_up[0..5].map{|d| {name: d}}}.to_json
          [200, {'Content-Type' => 'application/json'}, [json]]
        else
          [200, {'Content-Type' => 'text/html'}, ["<html><body>The cleaner today is: #{next_up.shift}, next up: #{next_up[0..5]}</body></html>"]]
        end
      }
    end
  end
end
