require 'mailgun'
class User < ActiveRecord::Base
# Added by Koudoku.
  has_one :subscription

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable




  has_one :location
  # accepts_nested_attributes_for :location

  has_many :offices
  has_many :clients
  has_many :caregivers
  has_many :reminders
  has_many :calls # easy query for payments
  has_many :services


  def first_name
    space_index = self.name.index(" ")
    if space_index and space_index > 2
      first_name = self.name[0...space_index]
      return first_name
    end
  end

  def set_basic_services
    #Create basic services
    if self.services.count == 0
      services = [
        "Did you wash dishes for the patient?",
        "Did you feed the patient?",
        "Did you assist with bathing the patient?",
        "Did you do light house keeping?",
        "Did you assisst patient with grooming?",
        "Did you do laundry?",
        "Did you prepare meal for patient?",
        "Did you remind patient to take medications?",
        "Did you help patient with mobility or transfer?"
      ]

      services.each do |s|
        service = Service.new
        service.service = s
        service.save
        self.services.push service
      end

      self.send_welcome_email #this should only happen once
    end
  end

  def send_welcome_email
    # using mailgun
    name = self.first_name
    email = self.email
    mail = Mail.deliver do
      to      "#{email}" # change to self.email
      from    'Serena Jay <serena@support.callia.us>'
      subject 'Welcome to Callia'

      text_part do
        body "Hi #{name},\n"+
        "Thanks for signing up. I'm so excited to get started.\n\n" +
        "To help you get going, I've added a link to a Quick Start Guide.\n\n" +
        "www.callia.us/quickstart \n" +
        "Callia is easy use and this Quick Start Guide is the perfect place to start!\n\n" +
        "Thanks,\n" +
        "Serena"
      end
    end

  end

  def charge_for_calls
    if self.subscription
      customer_id = self.subscription.stripe_id
      number_of_calls = self.call_counter
      ppc = self.price_per_call
      cost = (number_of_calls * 0.15) * 100
      if customer_id
        charge = Stripe::Charge.create(
          :amount => 1500, # $15.00 this time
          :currency => "usd",
          :customer => customer_id, # Previously stored, then retrieved
        )
      end
    end
  end

  def check_on_subscription
    if self.subscription and self.next_billing_date and (Time.now > self.next_billing_date - 1.day)
      sid = self.subscription.stripe_id
      if sid
        # user has subscription
        p "user has subscription"
        #get the plan id
        plan_id = Stripe::Customer.retrieve(sid).subscriptions.first.plan.id
        if plan_id
          find_cpc(plan_id) # cost per call
        end
      end
    else
      p "User has no subscription or Missing Next Billing Date"
    end
  end

  def find_cpc(plan_id)
    if self.calls_this_month and self.calls_this_month > 0
      if plan_id == "starter-plan-1599"
        cpc = 0.15 # cost per call
        free_calls = 25
        create_invoice(cpc, free_calls)
      elsif plan_id == "standard-plan-2399"
        cpc = 0.10
        free_calls = 50
        create_invoice(cpc, free_calls)
      elsif plan_id == "enterprise-plan-5999"
        cpc = 0.05
        free_calls = 250
        create_invoice(cpc, free_calls)
      end
    end
  end

  def create_invoice(cpc, free_calls)
    amount = 0
    amount = ((cpc * (self.calls_this_month - free_calls)) * 100)
    if self.subscription and amount > 0
      Stripe::InvoiceItem.create(
        :customer => self.subscription.stripe_id,
        :amount => amount.to_i,
        :currency => "usd",
        :description => "Number of Calls (#{self.calls_this_month}). We've subtracted your free calls. Free Calls: #{free_calls}",
      )
      reset_the_calls
    else
      reset_the_calls
    end
  end

  def reset_the_calls
    self.calls_this_month = 0
    self.save
  end

  def update_next_billing_date
    if (!self.next_billing_date) or (Time.now > next_billing_date)
      # Get NBD
      if self.subscription
        sid = self.subscription.stripe_id
        subs = Stripe::Customer.retrieve(sid).subscriptions
        if subs
          if subs.first
            self.next_billing_date = Time.at(subs.first.current_period_end)
            p "updated Billing Date"
            self.save
          end
        end
      end
    end
  end

  def check_for_missed_clock_outs
    self.calls.where(log_type: "Clocked In").where("clock_out_call_id IS NULL").each do |c|
      if c.created_at < 16.hours.ago
        # this is a unusually long work duration, the caregiver must have forgot to clock out
        call = Call.new
        call.log_type = "Missed Clock Out"
        call.caregiver = c.caregiver
        call.client = c.client
        call.clock_in_call = c.id
        call.save
      end
    end
  end

end
