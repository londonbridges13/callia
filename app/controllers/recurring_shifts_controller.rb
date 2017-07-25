class RecurringShiftsController < ApplicationController
  before_action :set_recurring_shift, only: [:show, :edit, :update, :destroy]

  # GET /recurring_shifts
  # GET /recurring_shifts.json
  def index
    @recurring_shifts = RecurringShift.all
  end

  # GET /recurring_shifts/1
  # GET /recurring_shifts/1.json
  def show
  end

  # GET /recurring_shifts/new
  def new
    @recurring_shift = RecurringShift.new
  end

  # GET /recurring_shifts/1/edit
  def edit
  end

  # POST /recurring_shifts
  # POST /recurring_shifts.json
  def create
    @recurring_shift = RecurringShift.new(recurring_shift_params)

    respond_to do |format|
      if @recurring_shift.save
        format.html { redirect_to @recurring_shift, notice: 'Recurring shift was successfully created.' }
        format.json { render :show, status: :created, location: @recurring_shift }
      else
        format.html { render :new }
        format.json { render json: @recurring_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recurring_shifts/1
  # PATCH/PUT /recurring_shifts/1.json
  def update
    respond_to do |format|
      if @recurring_shift.update(recurring_shift_params)
        format.html { redirect_to @recurring_shift, notice: 'Recurring shift was successfully updated.' }
        format.json { render :show, status: :ok, location: @recurring_shift }
      else
        format.html { render :edit }
        format.json { render json: @recurring_shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurring_shifts/1
  # DELETE /recurring_shifts/1.json
  def destroy
    @recurring_shift.destroy
    respond_to do |format|
      format.html { redirect_to recurring_shifts_url, notice: 'Recurring shift was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurring_shift
      @recurring_shift = RecurringShift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recurring_shift_params
      params.require(:recurring_shift).permit(:frequency, :time_span, :end_recurrence_date)
    end
end
