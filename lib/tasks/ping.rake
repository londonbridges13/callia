require 'net/http'

namespace :ping do
  desc "Ping our heroku dyno every 10, 60 or 3600 min"
  task :start do
    puts "Making the attempt to ping the dyno"

    if ENV['URL']
      puts "Sending ping"

      uri = URI(ENV['URL'])
      Net::HTTP.get_response(uri)

      puts "ping successful..."

      #Check for missed Clocked outs 
      calls = Call.where()
    end
  end
end

def check_for_missed_clock_outs(user)
  user.calls.where(log_type: "Clocked In").where(clock_out_call).each do |c|

  end
end
