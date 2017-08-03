class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  # GET /shifts
  # GET /shifts.json
  def index
    shifts = []
    current_user.clients.each do |c|
      c.shifts.order("start_time ASC").each do |s|
        unless shifts.include? s
          shifts.push s
        end
      end
    end
    @shifts = shifts
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
    @recurring_shift = RecurringShift.new
    @frequencies = [["Select", 9999],["Daily", 1], ["Weekly", 7], ["Bi-Weekly", 14], ["Monthly", 28]]
    det = Date.today + 365.days
    @default_end_time = "#{det.month}/#{det.day}/#{det.year}"
    @count = 0
  end

  # GET /shifts/1/edit
  def edit
    @count = 0
    if @shift.recurring_shift
      p "Has RecurringShift"
      @recurring_shift = @shift.recurring_shift
      det = @recurring_shift.end_recurrence_date
      @default_end_time = @recurring_shift.time_span
      @frequencies = [["Select", 9999], ["Daily", 1], ["Weekly", 7], ["Bi-Weekly", 14], ["Monthly", 28]]
      @selected_frequency = @recurring_shift.frequency
    else
      p "Has no RecurringShift"
      @recurring_shift = RecurringShift.new
      det = Date.today + 365.days
      @default_end_time = "#{det.month}/#{det.day}/#{det.year}"
      @frequencies = [["Select", 9999], ["Daily", 1], ["Weekly", 7], ["Bi-Weekly", 14], ["Monthly", 28]] # select should never repeat
    end
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(shift_params)
    @recurring_shift = RecurringShift.new(recurring_shift_params)
    respond_to do |format|
      if @shift.save
        @shift.set_duration
        @shift.office = @shift.caregiver.office
        @recurring_shift.end_recurrence_date = Date.strptime(@recurring_shift.time_span, "%m/%d/%Y")
        if @recurring_shift.frequency and @recurring_shift.end_recurrence_date and (@recurring_shift.frequency < 99)
          @recurring_shift.save
          create_recurring_shifts
        end
        created_shift_activity
        format.html { redirect_to shifts_url, notice: 'Shift was successfully created.' }
        format.json { render :index, status: :created, location: shifts_url }
      else
        format.html { render :new }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shifts/1
  # PATCH/PUT /shifts/1.json
  def update
    respond_to do |format|
      if @shift.update(shift_params)
        @shift.set_duration
        if @shift.recurring_shift
          @recurring_shift = @shift.recurring_shift
          p "Updating old Recurring Shift"
          # has this changed?
          update_recurring_shift_value # if possible
        else
          p "Creating new Recurring Shift"
          @recurring_shift = RecurringShift.new(recurring_shift_params)
          @recurring_shift.end_recurrence_date = Date.strptime(@recurring_shift.time_span, "%m/%d/%Y")
          @recurring_shift.save
          create_recurring_shifts # must create because there was no recurrence before
        end
        updated_shift_activity
        format.html { redirect_to shifts_url, notice: 'Shift was successfully updated.' }
        format.json { render :index, status: :ok, location: shifts_url }
      else
        format.html { render :edit }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end


  def create_recurring_shifts
      p "Creating multiple Recurring Shifts"
      # here is where the magic happens
      #first add the @shift to the recurring_shift.shifts
      unless @recurring_shift.shifts.include? @shift
        @recurring_shift.shifts.push @shift
      end

      # now create the func that you've written on paper (while loop)

      end_date = @recurring_shift.end_recurrence_date
      latest_shift = @shift
      frequency = @recurring_shift.frequency

      if frequency and end_date
        p "(Good) not missing frequency or end_recurrence_date"
        while (latest_shift.start_time < end_date)
          #create new shift
          #check if new_shift.start_time < end_date
          # if so, save new_shift and set as latest_shift
          # if not, just set as latest_shift so that the loop can end

          #create new shift
          new_shift = Shift.new
          new_shift.start_time = latest_shift.start_time + frequency.days #test
          new_shift.end_time = latest_shift.end_time + frequency.days #test
          new_shift.caregiver = latest_shift.caregiver
          new_shift.client = latest_shift.client
          new_shift.notes = latest_shift.notes
          new_shift.status = latest_shift.status
          new_shift.set_duration
          new_shift.office = new_shift.caregiver.office

          #check if new_shift.start_time < end_date
          if new_shift.start_time < end_date
            # if so, save new_shift and set as latest_shift
            p "new_shift"
            new_shift.save
            latest_shift = new_shift
            unless @recurring_shift.shifts.include? new_shift
              @recurring_shift.shifts.push new_shift
            end
          else
            # if not, just set as latest_shift so that the loop can end
            p "no new_shift"
            latest_shift = new_shift
          end
        end #end of loop
      else
        p "missing frequency or end_recurrence_date"
      end
  end
  helper_method :create_recurring_shifts

  def update_recurring_shifts
    # delete all future shifts that are link to this recurring shift
    # create new shifts
    p "Updating all future shifts..."
    p "For Shift: #{@shift.id}"

    delete_all_future_shifts

    end_date = @recurring_shift.end_recurrence_date
    latest_shift = @shift
    frequency = @recurring_shift.frequency

    if frequency and end_date
      p "(Good) not missing frequency or end_recurrence_date"
      while (latest_shift.start_time < end_date)
        #create new shift
        #check if new_shift.start_time < end_date
        # if so, save new_shift and set as latest_shift
        # if not, just set as latest_shift so that the loop can end

        #create new shift
        new_shift = Shift.new
        new_shift.start_time = latest_shift.start_time + frequency.days #test
        new_shift.end_time = latest_shift.end_time + frequency.days #test
        new_shift.caregiver = latest_shift.caregiver
        new_shift.client = latest_shift.client
        new_shift.notes = latest_shift.notes
        new_shift.status = latest_shift.status
        new_shift.set_duration
        new_shift.office = new_shift.caregiver.office

        #check if new_shift.start_time < end_date
        if new_shift.start_time < end_date
          # if so, save new_shift and set as latest_shift
          p "new_shift"
          new_shift.save
          latest_shift = new_shift
          unless @recurring_shift.shifts.include? new_shift
            @recurring_shift.shifts.push new_shift
          end
        else
          # if not, just set as latest_shift so that the loop can end
          p "no new_shift"
          latest_shift = new_shift
        end
      end #end of loop
    else
      p "missing frequency or end_recurrence_date"
    end
  end

  def delete_all_future_shifts
    date = @shift.start_time

    future_shifts = Shift.all.where(recurring_shift: @shift.recurring_shift).where("start_time > ?", date)
    future_shifts.each do |s|
      s.delete
    end 
  end


  def recurrence_has_changed(frequency = nil, time_span = nil)
    p frequency
    p time_span
    if frequency and time_span
      if @shift.recurring_shift and  @shift.recurring_shift.frequency == frequency and  @shift.recurring_shift.time_span = time_span
        return false
      else #we check for recurring_shift in the form so we should be ok
        return true
      end
    end
  end
  helper_method :recurrence_has_changed

  def update_recurring_shift_value
    # take the params and use them for the recurring_shift
    p "take the params and use them for the recurring_shift"
    new_recurring_shift = RecurringShift.new(recurring_shift_params)
    if new_recurring_shift
      # compare old to the params
      p "compare old to the params"
      if (new_recurring_shift.frequency == @recurring_shift.frequency) and (new_recurring_shift.time_span == @recurring_shift.time_span)
        #they are the same, do nothing
        p "they are the same, do nothing"
      else
        # update the @recurring_shift attributes
        # then run update all future shifts
        if @shift.recurring_shift.update(recurring_shift_params)
          # then run update all future shifts
          p "then run update all future shifts"
          update_recurring_shifts
        end
      end
    else
      # else this should have been created
      p "else this should have been created"
    end
  end

  def created_shift_activity
    if @shift.client
      @shift.save_activity("#{current_user.name} created shift for #{@shift.client.name} with #{@shift.caregiver.name}", current_user, @shift)
    end
  end

  def updated_shift_activity
    if @shift.client
      @shift.save_activity("#{current_user.name} updated shift for #{@shift.client.name} with #{@shift.caregiver.name}", current_user, @shift)
    end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @shift.activities.each do |a|
      a.shift = nil
      a.save
    end
    @shift.services.each do |s|
      s.shift = nil
      s.save
    end
    @shift.destroy
    respond_to do |format|
      format.html { redirect_to shifts_url, notice: 'Shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_params
      params.require(:shift).permit(:start_time, :end_time, :duration, :notes, :status, :client_id, :caregiver_id)
    end
    def recurring_shift_params
      params.require(:recurring_shift).permit(:frequency, :time_span, :end_recurrence_date)
    end
end
