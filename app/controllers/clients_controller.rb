class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :display_client, only: [:index]

  # GET /clients
  # GET /clients.json
  def index
    @clients = current_user.clients.all#Client.all
    get_clients

    clients_info = []
    @user_clients.each do |c|
      # [[client.id, client.name, client.desc, client.notes, client.activities, client.shifts],...]
      array = []

      if c.id
        array.push c.id
      else
        array.push ""
      end

      if c.name
        array.push c.name
      else
        array.push ""
      end

      if about_client(c)
      array.push about_client(c)
      else
        array.push ""
      end

      if c.notes
        array.push c.notes
      else
        array.push ""
      end
      activities = c.activities.limit(5).order('created_at DESC')
      if activities and activities.count > 0
        activity_array = []
        activities.each do |a|
          activity_array.push [a.activity, a.created_at.to_formatted_s(:short)]
        end
        array.push activity_array
      else
        array.push ""
      end

      shifts = c.shifts.limit(5).order('created_at DESC')
      if shifts
        shift_array = []
        shifts.each do |s|
          shift_array.push ["#{s.start_time.strftime("%I:%M %p")} - #{s.end_time.strftime("%I:%M %p")}", "#{s.start_time.strftime("%A")}"]
        end
        array.push shift_array
      else
        array.push ""
      end


      clients_info.push array
    end
    gon.your_int = 65
    gon.clients_info = clients_info
  end

  def get_clients()

    @user_clients = []
    current_user.offices.each do |o|
      o.clients.each do |c|
        @user_clients.push c
      end
    end
    @selected_client = current_user.clients.first
    if @selected_client
      @about_selected_client = about_client @selected_client
    else
      @about_selected_client = ''
    end
    @first_activity = @selected_client.activities.order('created_at DESC').first
  end

  def display_client
    # @selected_client = current_user.clients.first
  end
  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  def about_client(client)
    # display details on the client
    return "#{client.name} has #{client.shifts.count} shifts." # do better
  end



  # GET /clients/new
  def new
    @client = Client.new
    present_options
  end

  def save_client
    @client.set_code(@client.office, current_user)
    #record activity
    created_client_activity
  end

  # GET /clients/1/edit
  def edit
    present_options
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        save_client
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        updated_client_activity
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end


  def created_client_activity
      @client.save_activity("#{current_user.name} added client: #{@client.name}", current_user, @client)
  end

  def updated_client_activity
      @client.save_activity("#{current_user.name} updated client: #{@client.name}", current_user, @client)
  end

  def present_options
    @offices = []
    current_user.offices.each do |o|
      element = [o.name,o]
      @offices.push o#element
    end
    if @offices.first
      @selected_office = @offices.first.id
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
      # @selected_client = current_user.clients.last

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :client_code, :authorized_phone, :status, :notes,
      :office, :office_id)
    end
end
