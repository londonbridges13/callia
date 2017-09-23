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
    s = s.gsub! "-", "/"
  end

  def weekly_report
    render :layout => "empty"

  end

end
