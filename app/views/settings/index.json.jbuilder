json.array!(@settings) do |setting|
  json.extract! setting, :id, :first_name, :allow_reminder_for_birthdays
  json.url setting_url(setting, format: :json)
end
