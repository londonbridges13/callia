require 'net/http'

namespace :ping do
  desc "Ping our heroku dyno every 10, 60 or 3600 min"
  task :start => :environment do
    puts "Making the attempt to ping the dyno"

    if ENV['URL']
      puts "Sending ping"

      uri = URI(ENV['URL'])
      Net::HTTP.get_response(uri)

      puts "ping successful..."

      #Check for missed Clocked outs
      users = User.all
      users.each do |u|
        u.check_for_missed_clock_outs # function moved to model
      end
    end
  end
end
