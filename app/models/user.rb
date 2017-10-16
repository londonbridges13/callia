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
  has_many :sections


  def set_sections
    if self.sections.count == 0
      basics = ["PERSONAL CARE (PC)",
        "HOMEMAKER / CHORE (HC)",
        "ADVANCED PERSONAL CARE (APC)",
        "RESPITE CARE (R)",
        "OTHER (O)"]

      user_sections = []

      self.sections.each do |s|
        user_sections.push s.section
      end
      basics.each do |b|
        unless user_sections.include? b
          # create section
          section = Section.new(section: b)
          section.save
          self.sections.push section

        end
      end
    end

  end

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
        ["Did you wash dishes for the patient?","Wash Dishes", "HOMEMAKER / CHORE (HC)"],
        ["Did you feed the patient?", "Feed Patient", "HOMEMAKER / CHORE (HC)"],
        ["Did you assist with bathing the patient?", "Bathing & Personal Hygiene", "HOMEMAKER / CHORE (HC)"],
        ["Did you do light house keeping?", "Light House Keeping", "HOMEMAKER / CHORE (HC)"],
        ["Did you assisst patient with grooming?", "Dressing and Grooming", "PERSONAL CARE (PC)"],
        ["Did you do laundry?", "Laundry", "HOMEMAKER / CHORE (HC)"],
        ["Did you prepare meal for patient?", "Prepare Meal", "HOMEMAKER / CHORE (HC)"],
        ["Did you remind patient to take medications?", "Assist w/Self Adm of Meds & Non-Prescrip Top Oints/ Lotions", "PERSONAL CARE (PC)"],
        ["Did you help patient with mobility or transfer?","Mobility & Transfer", "PERSONAL CARE (PC)"]
      ]

      services.each do |s|
        service = Service.new
        service.service = s[0]
        service.short_desc = s[1]
        service.section = s[2]
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
    if self.subscription and self.next_billing_date
      if (Time.now > self.next_billing_date - 1.day) #If the current time is less than 24 hours before billing date, charge the user
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
        p "User is not due yet"
      end
    else
      p "User has no subscription or Missing Next Billing Date"
    end
  end

  def find_cpc(plan_id)
    if self.calls_this_month and self.calls_this_month > 0
      if plan_id == "enterprise-plan-230"
        cpc = 0.05 # cost per call
        free_calls = 1000
        create_invoice(cpc, free_calls)
      elsif plan_id == "standard-plan-2399"
        cpc = 0.12
        free_calls = 50
        create_invoice(cpc, free_calls)
      elsif plan_id == "enterprise-plan-5999"
        cpc = 0.10
        free_calls = 250
        create_invoice(cpc, free_calls)
      end
    end
  end

  def create_invoice(cpc, free_calls)
    amount = 0
    amount = ((cpc * (self.calls_this_month - free_calls)) * 100)
    if self.subscription# and amount > 0 #Just to see the invoice
      Stripe::InvoiceItem.create(
        :customer => self.subscription.stripe_id,
        :amount => amount.to_i,
        :currency => "usd",
        :description => "Number of Calls (#{self.calls_this_month}).Free Calls: #{free_calls}. (We've subtracted your free calls)",
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
        call.caller_number = c.caller_number
        call.clock_out_call = c # AGAIN SOMETHING WIERD IS HAPPENING WITH THE clock_out_call AND clock_in_call (MUST BE IN THE MODEL/SCHEME/MIGRATION)
        call.user = self
        call.save
        c.clock_in_call = call
        c.save
      end
    end
  end

  def remove_if_subscription_has_ended
    #these would be the users that ended their subscription with our service
    # if they have been existed for more than 21 days remove their acounts and free up their numbers
    # if they haven't, just remove their subscription

    if self.subscription
      # test subscription
      sid = self.last.subscription.stripe_id
      plan_id = Stripe::Customer.retrieve(sid).subscriptions.first.plan.id

      unless plan_id
        # there is no plan_id
        subscriptions = Stripe::Customer.retrieve(sid).subscriptions
        if !subscriptions
          # this user has canceled subscriptions
          total_count = Stripe::Customer.retrieve(sid).subscriptions.total_count
          if total_count == 0
            # STRIPE WORKS, THERE IS NO SYSTEM FAILURE, THIS USER HAS NO SUBSCRIPTION WITH STRIPE
            # REMOVE THEIR SUBSCRIPTION FROM CALLIA.
            #THAT IS ALL
            self.subscription.delete
          end
        end
      end
    elsif self.created_at > 21.days.ago and !self.subscription
      #user has no subscription for 21 days, remove this user and free the number
      if self.call_number
        number = PhoneNumber.where(user_id: self.id).first
        if number
          number.is_used = false
          number.user_id = nil
          number.save

          # delete the user
          self.clients.each do |c|
            c.delete
          end
          self.caregivers.each do |c|
            c.delete
          end
          self.offices.each do |c|
            c.delete
          end
          self.calls.each do |c|
            c.delete
          end
          self.services.each do |c|
            c.delete
          end
          if self.subscription
            self.subscription.delete
          end
          self.shifts.each do |c|
            c.delete
          end
          self.activities.each do |c|
            c.delete
          end
          self.delete
        end
      end
    end
  end

end
