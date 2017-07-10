class ReportsController < ApplicationController

  def index # changed for the ajax search for the reports pages
    # @search = Call.all.first#CallSearch.new(params[:search])
    # @calls = @search.scope
  end

  def call_logs #reports/call_logs
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

  def timecard_report #reports/call_logs
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

  def activity_report #reports/call_logs
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


  def convert_to_display(s = nil)
    s = s.gsub! "-", "/"
  end

end
