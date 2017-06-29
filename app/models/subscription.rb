class Subscription < ActiveRecord::Base
  include Koudoku::Subscription

  belongs_to :user
  belongs_to :coupon

  def load_plans
    #here I'm going to create the plans that I have on Stripe.
    #Run this one time in the terminal and heroku terminal

    plan = Plan.first
    unless plan
      Plan.create({
        name: 'Basic',
        price: 15.99,
        interval: 'month',
        stripe_id: 'basic-plan-1599',
        features: ['$0.15 per call', 'Recommended for less than 400 Monthly Calls','Recommended for less than 10 Clients', '25 Free Calls / Month', 'Save up to 20% / Month'].join("\n\n"),
        display_order: 1
      })

      Plan.create({
        name: 'Startup',
        price: 23.99,
        interval: 'month',
        stripe_id: 'startup-plan-2399',
        features: ['$0.12 per call', 'Recommended for 400 - 2000 Monthly Calls', 'Recommended for 10 - 50 Clients', '50 Free Calls / Month', "System Setup (We'll set up your account with employee and client information)"].join("\n\n"),
        display_order: 2
      })

      Plan.create({
        name: 'Business',
        highlight: true, # This highlights the plan on the pricing page.
        price: 59.99,
        interval: 'month',
        stripe_id: 'business-plan-5999',
        features: ['$0.10 per call', 'Recommended for 2000 - 4000 Monthly Calls','Recommended for 50 - 100 Clients', '250 Free Calls / Month', "System Setup (We'll set up your account with employee and client information)"].join("\n\n"),
        display_order: 3
      })

      Plan.create({
        name: 'Enterprise',
        price: 230.00,
        interval: 'month',
        stripe_id: 'enterprise-plan-230',
        features: ['$0.05 per call', 'Recommended for 4000+ Monthly Calls','Recommended for 100+ Clients', '500 Free Calls / Month', "System Setup (We'll set up your account with employee and client information)"].join("\n\n"),
        display_order: 4
      })
    end
  end
end