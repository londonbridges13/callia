class ReportsController < ApplicationController

  def index # changed for the ajax search for the reports pages
    # @calls = @search.scope
  end

  def call_logs
    # @caregivers = current_user.caregivers
    @search = ReportSearch.new(params[:search])

    if @search.date_to
      @search.convert_to_display(@search.date_to)
    end
    if @search.date_from
      @search.convert_to_display(@search.date_from)
    end
    @calls = @search.scope(current_user.id)#current_user.calls.order("created_at DESC")
  end

  def timecard_report
    # @caregivers = current_user.caregivers
    @search = ReportSearch.new(params[:search])

    if @search.date_to
      @search.convert_to_display(@search.date_to)
    end
    if @search.date_from
      @search.convert_to_display(@search.date_from)
    end
    @calls = @search.scope_timecard(current_user.id)#current_user.calls.order("created_at DESC")
  end

  def activity_report
    # @caregivers = current_user.caregivers
    @search = ReportSearch.new(params[:search])

    if @search.date_to
      @search.convert_to_display(@search.date_to)
    end
    if @search.date_from
      @search.convert_to_display(@search.date_from)
    end
    @calls = @search.scope_activity(current_user.id)#current_user.calls.order("created_at DESC")
  end

  def custom_prompt_report
    # @caregivers = current_user.caregivers
    @search = ReportSearch.new(params[:search])

    if @search.date_to
      @search.convert_to_display(@search.date_to)
    end
    if @search.date_from
      @search.convert_to_display(@search.date_from)
    end
    @calls = @search.scope_custom_prompt(current_user.id)#current_user.calls.order("created_at DESC")
    services = []
    @calls.each do |c|
      c.services.each do |s|
        services.push s
      end
    end
    @services = services
  end

  def evv_recording
    # @caregivers = current_user.caregivers
    @search = ReportSearch.new(params[:search])

    if @search.date_to
      @search.convert_to_display(@search.date_to)
    end
    if @search.date_from
      @search.convert_to_display(@search.date_from)
    end
    @calls = @search.scope_evv(current_user.id)#current_user.calls.order("created_at DESC")
  end

  def convert_to_display(s = nil)
    # s = s.gsub! "-", "/"
    s.to_date.strftime("%m/%d/%Y")

  end

  def weekly_report
    something = params[:anything]
    @start = params[:start]
    @end = params[:end]
    if something
      #get client and caregiver
      @client = Client.find_by_id(something[:client_id])
      @caregiver = Caregiver.find_by_id(something[:caregiver_id])
      p @client
      p @caregiver
      p @start

      start_weekly_report(@start, @end)

    end

    # get calls that link to both client and caregiver
    calls = Call.all.where(caregiver: @caregiver).where(client: @client).where(log_type: "Clocked Out")
    services = []
    calls.each do |c|
      # collect all services
      c.services.each do |s|
        services.push s
      end
    end
    render :layout => "empty"
  end

  def start_weekly_report(start_date, end_date)
    @start_date = Date.strptime(start_date, "%m/%d/%Y")
    @end_date = Date.strptime(end_date, "%m/%d/%Y")

    num_of_days = (@end_date - @start_date).to_i + 1
    @num_of_days = num_of_days
    @array_days = []
    @all_services = []

    count = 0
    num_of_days.times do
      @array_days.push (@start_date + count.days)
      count += 1
    end

    @array_days.each do |d|
      calls = Call.where('created_at BETWEEN ? AND ?', d.to_datetime + 6.hours, d.to_datetime + 30.hours).where(user_id: current_user.id).where(log_type: "Clocked Out")
      services = []

      calls.each do |c|
        c.services.each do |s|
          services.push s
        end
      end
      @all_services.push services
    end
    # run service to array activity_checklist
    create_activities

  end

  def create_activities
    #create activities
    p "create_activities"
    unless @activities_checklist
      #create it using timesheet and user's services (really just user's services)
      # create the same number of activites as there are in the days, add to array @activities_checklist
      # an array within an array
      @activities_checklist = []
      # create list_of_services
      list_of_services = []
      #collect all the service questions, don't repeat
      # HERE is where we collect all activities displayed in the checklist
      #MAY WANT TO COME BACK TO ADD THE DEFAULT ACTIVITIES TO THE TIMESHEET
      @all_services.each do |list|
        list.each do |s|
          unless list_of_services.include? s.service
            list_of_services.push [s.service, ""]
          end
        end
      end

      @num_of_days.times do
        # push list_of_services to @activity_checklist
        @activities_checklist.push list_of_services
      end
      #now we have an array for the activities on the weekly report
      begin_activity_checklist
    end
  end

  def begin_activity_checklist#(services_array, date)
    #create activities, run the create_activities function
    # if activity has service on this day, activity has an √
    p "begin_activity_checklist"

    count = 0
    # compare the activities_checklist[a_days_activities_array] to the @all_services[a_days_services_array]
    @organized_activity = [] #by section

    @num_of_days.times do
      # if @activities_checklist.count >= count

        if @all_services.count >= count and @all_services[count].count > 0
          @all_services[count].each do |s|
            #check if response is yes
            a_section = []
            if s.response == "Yes"
              # set check for activity
              # a[1] = "√"
            end
            if s.section
              a_section.push s.section # never used
            else
              section = find_section_for_service s
              a_section.push section
            end
            small_array = []
            small_array.push count #s.created_at
            if s.short_desc
              small_array.push s.short_desc
            else
              small_array.push s.service
            end

            if s.response == "Yes"
              small_array.push "√"
            else
              small_array.push ""
            end
            a_section.push small_array
            @organized_activity.push a_section
          end
        end

      # end
      count += 1
    end
    p @activities_checklist
    p ""
    p ""
    p ""
    p @all_services
    p ""
    p ""
    p @organized_activity
    p ""
    p ""
    p ""
    display_table
  end

  def find_section_for_service(service)
    section = Service.where(user: current_user).where(service: service.service).first
    if section and section.section
      return section.section #look up
    else
      return "OTHER (O)"
    end

  end

  def display_table
    existing_sections = []
    @displayable_sections = []

    @organized_activity.each do |a|
      if existing_sections.include? a[0]
        i = existing_sections.index(a[0])
        @displayable_sections[i].push [a[1][0],a[1][1],a[1][2]]
      else
        existing_sections.push a[0]
        @displayable_sections.push a
      end
    end
    p "@displayable_sections"
    p @displayable_sections
  end


  def organize_services
    @sections = current_user.sections.reverse
    sections = []

    @organized_services = []
    current_user.services.each do |s|
      # collect all sections
      if !(sections.include? [s.section, s.service]) and s.section
        # add section to sections
        sections.push [s.section, s]
      elsif !s.section
        # add to other
        sections.push ["OTHER (O)", s]
      end
    end
    @organized_services = sections
    p @organized_services
  end

  def search_weekly_report
    default_start = Date.today.beginning_of_week(:sunday)
    default_end = default_start + 6.days

    @default_start = default_start.to_date.to_s # convert
    @default_end = default_end.to_date.to_s # convert
    @start = convert_to_display(@default_start)
    @end = convert_to_display(@default_end)


  end

end
