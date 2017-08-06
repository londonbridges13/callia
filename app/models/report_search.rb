require 'date'

class ReportSearch
  attr_reader :date_from, :date_to

  def initialize(params)
    params ||= {}
    @date_from = parsed_date(covert_to_scope(params[:date_from]), 7.days.ago.to_date.to_s)#parsed_date(params[:date_from], 17.days.ago.to_date.strftime("%m/%d/%Y"))
    @date_to = parsed_date(covert_to_scope(params[:date_to]), (Time.now).to_s)

    p params[:date_from]
    p params[:date_to]
    p covert_to_scope params[:date_from]
    p covert_to_scope params[:date_to]
    p @date_to
    p @date_from
  end

  def scope(id)
    dfrom = @date_from
    dto = @date_to
    # convert_to_display @date_from
    # convert_to_display @date_to
    return Call.where('created_at BETWEEN ? AND ?', dfrom.to_datetime + 6.hours, dto.to_datetime + 6.hours).where(user_id: id) # works

  end

  def scope_timecard(id)
    dfrom = @date_from
    dto = @date_to
    # convert_to_display @date_from
    # convert_to_display @date_to
    return Call.where('created_at BETWEEN ? AND ?', dfrom.to_datetime + 6.hours, dto.to_datetime + 23.hours + 58.minutes).where(user_id: id).where("log_type = 'Clocked Out'")
  end

  def scope_activity(id)
    dfrom = @date_from
    dto = @date_to
    # convert_to_display @date_from
    # convert_to_display @date_to
    return Call.where('created_at BETWEEN ? AND ?', dfrom.to_datetime + 6.hours, dto.to_datetime + 6.hours).where(user_id: id)
  end

  def scope_custom_prompt(id)
    dfrom = @date_from
    dto = @date_to
    # convert_to_display @date_from
    # convert_to_display @date_to
    return Call.where('created_at BETWEEN ? AND ?', dfrom.to_datetime + 6.hours, dto.to_datetime + 6.hours).where(user_id: id).where(log_type: "Clocked Out")
  end

  def scope_evv(id)
    dfrom = @date_from
    dto = @date_to
    # convert_to_display @date_from
    # convert_to_display @date_to
    return Call.where('created_at BETWEEN ? AND ?', dfrom.to_datetime + 6.hours, dto.to_datetime + 6.hours).where(user_id: id).where(log_type: "Clocked In")
  end

  def convert_to_display(s = nil)
    s.to_date.strftime("%m/%d/%Y")
  end

  def covert_to_scope(s = nil)
    if s and s.include? "/"
      p "This is s: #{s}"
      # s.to_date.to_s#.gsub! "/", "-"
      # s.to_date.strftime("%Y-%m-%d")
      Date.strptime(s, "%m/%d/%Y").to_s
    end

  end


  private

  def parsed_date(dateString, default)
    Date.parse(dateString)
  rescue ArgumentError, TypeError
    default
  end


end
