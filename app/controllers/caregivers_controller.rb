class CaregiversController < ApplicationController
  before_action :set_caregiver, only: [:show, :edit, :update, :destroy]

  # GET /caregivers
  # GET /caregivers.json
  def index
    @caregivers = current_user.caregivers#Caregiver.all
    if current_user.offices.count == 0
      redirect_to "/offices/new"
    elsif current_user.clients.count == 0
      redirect_to "/clients/new"
    end
    @result = request.remote_ip
    p "Result is #{@result}"
  end

  # GET /caregivers/1
  # GET /caregivers/1.json
  def show
  end

  # GET /caregivers/new
  def new
    @caregiver = Caregiver.new
    present_options

    if current_user.offices.count == 0
      redirect_to "/offices/new"
    end
  end

  def present_options
    @offices = []
    @selected_offices = []
    current_user.offices.each do |o|
      element = [o.name,o]
      @offices.push o#element
      @selected_offices.push o.id
    end
  end

  def save_caregiver
    @caregiver.set_code(@caregiver.office)
    @caregiver.set_user(current_user)
    #record activity
    created_employee_activity
  end

  def add_options
    # @selected_office.caregivers.push @caregiver
    # @caregiver.office = @selected_office
  end


  # GET /caregivers/1/edit
  def edit
    present_options
  end

  # POST /caregivers
  # POST /caregivers.json
  def create
    @caregiver = Caregiver.new(caregiver_params)
    respond_to do |format|
      if @caregiver.save
        save_caregiver
        format.html { redirect_to caregivers_url, notice: 'Caregiver was successfully created.' }
        format.json { render :index, status: :created, location: caregivers_url }
      else
        format.html { render :new }
        format.json { render json: @caregiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /caregivers/1
  # PATCH/PUT /caregivers/1.json
  def update
    respond_to do |format|
      if @caregiver.update(caregiver_params)
        add_options
        updated_employee_activity
        format.html { redirect_to caregivers_url, notice: 'Caregiver was successfully updated.' }
        format.json { render :index, status: :ok, location: caregivers_url }
      else
        format.html { render :edit }
        format.json { render json: @caregiver.errors, status: :unprocessable_entity }
      end
    end
  end


  #
  def created_employee_activity
    @caregiver.save_activity("#{current_user.name} created employee: #{@caregiver.name}", current_user, @caregiver)
  end

  def updated_employee_activity
    @caregiver.save_activity("#{current_user.name} updated employee: #{@caregiver.name}", current_user, @caregiver)
  end
  # DELETE /caregivers/1
  # DELETE /caregivers/1.json
  def destroy
    name = @caregiver.name
    @caregiver.save_activity("#{current_user.name} deleted employee: #{name}", current_user, @caregiver)
    clear_all_connections
    @caregiver.destroy
    respond_to do |format|
      format.html { redirect_to caregivers_url, notice: 'Caregiver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def clear_all_connections
    @caregiver.shifts.clear
    @caregiver.activities.clear
    @caregiver.calls.clear
    @caregiver.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caregiver
      @caregiver = Caregiver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def caregiver_params
      params.require(:caregiver).permit(:name, :employee_code, :address, :city, :state, :status, :birth_date,
       :office, :office_id)
    end
end
