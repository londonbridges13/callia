require 'net/http'

namespace :billing do
  desc "Add Call Invoice for Accounts that are about to pay"
    puts "Staring Billing"


    #Check for missed Clocked outs
    users = User.all
    users.each do |u|
      u.check_on_subscription #handles billing
      u.update_next_billing_date #updates next billing date
    end
    puts "billing successful..."
end
