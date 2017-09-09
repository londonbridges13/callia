require "csv"
class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
  end


  def obtain_prospect
    url = "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1497012322.aspx"
    uri = params[:uri]
    @html = search_homecare_prospect(uri)#"kl"

    @urls = ["https://npidb.org/organizations/nursing_and_custodial_care/skilled-nursing-facility_314000000x/1124054366.aspx",
    "https://npidb.org/organizations/agencies/in-home-supportive-care_253z00000x/1497012322.aspx"]

    # to_csv @urls

    @data = []
    @urls.each do |s|
      info = search_homecare_prospect s
      @data.push info
    end

  end

  def export
    urls = params[:urls]
    data = []
    urls.each do |url|
      info = search_homecare_prospect(url)
      if info
        data << info#attributes.map{ |attr| url.send(attr) }
      end
    end

    respond_to do |format|
      format.html { redirect_to root_url }
      format.csv { send_data to_csv(data)}#data.to_csv }
    end
  end

  def search_homecare_prospect(url)# Create A Page/ Route In Routes.rb
    site = "#{Nokogiri::HTML(open(url))}"
    # return site
    #search for Contact Information, then scrap everything until it
    # then get the company name (search lead text-success, then scrap until >)

    company_name_index = site.index("lead text-success")
    text = site[company_name_index...site.length]
    opener_index = text.index(">")
    closer_index = text.index("<")
    company_name = text[opener_index + 1...closer_index]

    # return company_name

    # search for padding-left:20px;, then scrap until br> (clears the address)
    # scrap til >, (here is your city/town)
    # scrap until next <span>, (this is your state)
    city_name_index = site.index("padding-left:20px;")
    newtext = site[city_name_index...site.length]
    br_index = newtext.index("br>")
    newtext2 = newtext[br_index...site.length]
    closer_index = newtext2.index("<")
    span_index1 = newtext.index("<span>")
    closing_span_index1 = newtext2.index("</span>")
    # return newtext2
    city = newtext2[closer_index + 6...closing_span_index1]

    # return city

    span_index = newtext2.index(", <span>")

    newtext3 = newtext2[span_index...607]
    closing_span_index2 = newtext3.index("</span>")

    state = newtext3[8...closing_span_index2]

    # return state

    location = "#{city}, #{state}"
    opener_index = newtext.index(">")

    span_index = newtext.index("<span>")
    newtext3 = newtext[opener_index...site.length]
    closer_index = newtext.index("<")
    city_name = newtext[opener_index + 1...closer_index]

    # scrap until telephone, then scrap until >, here is your phone number
    phone_index = newtext3.index("telephone")
    newtext4 = newtext3[phone_index...phone_index + 300]
    closer_index2 = newtext4.index("</span>")
    telephone = newtext4[11...closer_index2]

    # return telephone

    #scrap until Authorized official, then scrap until <span>, here is your contact's name
    authorized_name_index = text.index("Authorized official")
    newtext5 = text[authorized_name_index...authorized_name_index + 1000]
    closer_index3 = newtext5.index("</span>")
    open_index3 = newtext5.index("<span>")
    name = newtext5[open_index3 + 6...closer_index3]
    # return name

    array = {
      "name" => name.delete!("\t").delete!("\n").delete!("\r"),
      "location" => location,
      "telephone" => telephone,
      "company" => company_name.delete!("\t").delete!("\n").delete!("\r")
    }

    return array
  end


  def to_csv(data)
    attributes = ["name", "location", "telephone", "company"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      data.each do |d|
        csv << d#[d.name,d.location, d.telephone, d.company]
      end

    end
  end


  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:first_name, :allow_reminder_for_birthdays)
    end
end
