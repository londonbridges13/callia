class ScheduleController < ApplicationController
  def index
    # calendar
  end

  def calendar
    events = []
    shifts = []
    current_user.clients.each do |c|
      c.shifts.each do |s|
        #add s to  the shifts
        shifts.push s
      end
    end
    shifts.each do |s|
      #set up for the events
      # if s.caregiver and s.client
        event = {
                  title: "#{s.caregiver.name} @ #{s.client.name}",
                  start: s.start_time.httpdate, #(year, month, day, hour24, minute)
                  end: s.end_time.httpdate, #(year, month, day, hour24, minute)
                  allDay: false
              }
        events.push event
      # end
    end
    @events = events
    p "@events #{@events}"
  end

end
