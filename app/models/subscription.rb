class Subscription < ActiveRecord::Base
  include Koudoku::Subscription

  belongs_to :user
  belongs_to :coupon

  def load_plans
    #here I'm going to create the plans that I have on Stripe.
    #Run this one time in the terminal and heroku terminal

    plan = Plan.first
    unless plan
      # Plan.create({
      #   name: 'Starter',
      #   price: 15.99,
      #   interval: 'month',
      #   stripe_id: 'starter-plan-1599',
      #   features: ['$0.15 per call', 'Recommended for less than 400 Monthly Calls','Recommended for less than 10 Clients', '25 Free Calls / Month', 'Save up to 20% / Month'].join("\n\n"),
      #   display_order: 1
      # })

      Plan.create({
        name: 'Standard',
        price: 23.99,
        interval: 'month',
        stripe_id: 'standard-plan-2399',
        features: ['$0.12 per clock in', 'Recommended for 1 - 50 Clients', '50 Free Clock Ins / Month'].join("\n\n"),
        display_order: 1
      })

      Plan.create({
        name: 'Business Premium',
        highlight: true, # This highlights the plan on the pricing page.
        price: 59.99,
        interval: 'month',
        stripe_id: 'enterprise-plan-5999',
        features: ['$0.10 per clock in', 'Recommended for 50 - 100 Clients', '250 Free Clock Ins / Month'].join("\n\n"),
        display_order: 2
      })

      Plan.create({
        name: 'Enterprise',
        price: 230.00,
        interval: 'month',
        stripe_id: 'enterprise-plan-230',
        features: ['$0.05 per clock in', 'Recommended for 100+ Clients', '1000 Free Clock Ins / Month'].join("\n\n"),
        display_order: 3
      })

    end
  end
end
