json.array!(@reminders) do |reminder|
  json.extract! reminder, :id, :reminder, :date, :notes
  json.url reminder_url(reminder, format: :json)
end
