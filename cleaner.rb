require "rack"
require "rack-cache"
require "shack"

app = Rack::Builder.new do
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
    the_list = ["Piet", "Sophie", "Gregory", "Bram", "Lewis", "Koen", "Maarten", "Tom", "Nathan", "Bob"]
    the_day_it_all_began = Time.mktime(2014, 11, 17)

    one_week = 60 * 60 * 24 * 7
    # Number of weeks % number of people = the week we're in.
    week_number = (((midnight - the_day_it_all_began) / one_week) % the_list.count).floor
    cleaner = the_list[week_number]
    [200, {'Content-Type' => 'text/html'}, ["<html><body>The cleaner today is: #{cleaner}</body></html>"]]
  }
end
Rack::Server.start app: app
