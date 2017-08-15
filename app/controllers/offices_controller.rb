class OfficesController < ApplicationController
  before_action :set_office, only: [:show, :edit, :update, :destroy]

  # GET /offices
  # GET /offices.json
  def index
    @offices = current_user.offices

    if current_user.caregivers.count == 0
      redirect_to "/caregivers/new"
    elsif current_user.clients.count == 0
      redirect_to "/clients/new"
    end
  end

  # GET /offices/1
  # GET /offices/1.json
  def show
    @activities = set_activities
    @activities.sort_by(&:created_at).reverse
    count_calls # get the amount of calls
    create_contact
  end

  def set_activities
    @activities = []
    @office.activities.each do |a|
      @activities.push a
      @activities.sort_by(&:created_at).reverse
    end
    @office.clients.each do |c|
      c.activities.each do |a|
        @activities.push a
      end
      @activities.sort_by(&:created_at).reverse
    end
    @office.caregivers.each do |c|
      c.activities.each do |a|
        @activities.push a
      end
      @activities.sort_by(&:created_at).reverse
    end
    @office.shifts.each do |c|
      c.activities.each do |a|
        @activities.push a
      end
      @activities.sort_by(&:created_at).reverse
    end
    return @activities.sort_by(&:created_at).reverse

    # @activities = Activity.where("client = 'Rails 3' OR activity = 'Rails 4'")
  end


  def count_calls
    @calls = 0
    clients = @office.clients
    clients.each do |c|
      c.calls.each do |call|
        @calls += 1
      end
    end
  end

  def create_contact
    @contact = Contact.new
  end

  # def save_office_contact
  #   if @office.contact.email or @office.contact.home_number or @office.contact.mobile_number
  #     # Save contant as office.contact
  #     @office.contact.save
  #   end
  # end


  # GET /offices/new
  def new
    @office = Office.new
    set_caregivers

  end

  # GET /offices/1/edit
  def edit
    set_caregivers
  end

  def set_caregivers
    caregivers = []
    current_user.offices.each do |o|
      o.caregivers.each do |c|
        caregivers.push c
      end
    end
    @caregivers = caregivers
  end
  # POST /offices
  # POST /offices.json
  def create
    @office = Office.new(office_params)

    respond_to do |format|
      if @office.save
        save_office
        # save_office_contact
        format.html { redirect_to @office, notice: 'Office was successfully created.' }
        format.json { render :show, status: :created, location: @office }
      else
        format.html { render :new }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offices/1
  # PATCH/PUT /offices/1.json
  def update
    respond_to do |format|
      if @office.update(office_params)
        set_supervisor
        # save_office_contact
        format.html { redirect_to @office, notice: 'Office was successfully updated.' }
        format.json { render :show, status: :ok, location: @office }
      else
        format.html { render :edit }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offices/1
  # DELETE /offices/1.json
  def destroy
    clear_all_connections
    @office.destroy
    respond_to do |format|
      format.html { redirect_to offices_url, notice: 'Office was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def clear_all_connections
    @office.shifts.clear
    @office.caregivers.clear
    @office.activities.clear
    @office.clients.clear
    @office.supervisor = nil
    @office.save
  end


  def save_office
    @office.set_code(current_user)
    unless current_user.offices.include? @office
      current_user.offices.push @office
    end
    #record activity
    @office.save_activity("#{current_user.name} created an office: #{@office.name}.", @office, current_user)
    set_supervisor
  end

  def set_supervisor
    if params[:supervisor_id]
      # find superviser
      sv = Caregiver.find_by_id(params[:supervisor_id])
      if sv
        @office.set_supervisor_activity("#{current_user.name} set #{sv.name} as supervisor for #{@office.name}",
          @office, current_user, @office.supervisor)
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_office
      @office = Office.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def office_params
      params.require(:office).permit(:name, :telephone, :office_code, :email, :supervisor_id,
       :location, :state, :city, :postcode, :address)
    end
end
