class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  # GET /shifts
  # GET /shifts.json
  def index
    @shifts = Shift.all
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
    @recurring_shift = RecurringShift.new
    @frequencies = [["Daily", 1], ["Weekly", 7], ["Bi-Weekly", 14], ["Monthly", 30]]
    det = Date.today + 365.days
    @default_end_time = "#{det.month}/#{det.day}/#{det.year}"
  end

  # GET /shifts/1/edit
  def edit
    if @shift.recurring_shift
      @recurring_shift = @shift.recurring_shift
    else
      @recurring_shift = RecurringShift.new
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
        @recurring_shift.end_recurrence_date = Date.strptime(@recurring_shift.time_span, "%m/%d/%Y")
        if @recurring_shift.frequency and @recurring_shift.end_recurrence_date
          @recurring_shift.save
          create_recurring_shifts
        end
        created_shift_activity
        format.html { redirect_to @shift, notice: 'Shift was successfully created.' }
        format.json { render :show, status: :created, location: @shift }
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
        if @recurring_shift
          if @recurring_shift.update(recurring_shift_params)
            update_recurring_shifts
          end
        else
          @recurring_shift = RecurringShift.new(recurring_shift_params)
          @recurring_shift.end_recurrence_date = Date.strptime(@recurring_shift.time_span, "%m/%d/%Y")
          @recurring_shift.save
          create_recurring_shifts # must create because there was no recurrence before
        end
        unless @recurring_shift.shifts.include? @shift
          @recurring_shift.shifts.push @shift
        end
        updated_shift_activity
        format.html { redirect_to @shift, notice: 'Shift was successfully updated.' }
        format.json { render :show, status: :ok, location: @shift }
      else
        format.html { render :edit }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end


  def create_recurring_shifts
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

  def update_recurring_shifts
    # for when the user updates the recurring_shifts
    # you may need to update the rest of the shifts
    # ask user in alert as to whether they would like to change the future shifts
    # if yes then delete all future shifts that are linked to this recurring_shift
    # and recreate them with the new frequency and time (run create_recurring_shifts again)
  end

  def created_shift_activity
    if @shift.client
      @shift.save_activity("#{current_user.name} created shift for #{@shift.client}", current_user, @shift)
    end
  end

  def updated_shift_activity
    if @shift.client
      @shift.save_activity("#{current_user.name} updated shift for #{@shift.client}", current_user, @shift)
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
