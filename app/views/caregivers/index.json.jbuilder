json.array!(@caregivers) do |caregiver|
  json.extract! caregiver, :id, :name, :employee_code, :address, :city, :state, :status, :birth_date
  json.url caregiver_url(caregiver, format: :json)
end
