json.array!(@contacts) do |contact|
  json.extract! contact, :id, :email, :mobile_number, :home_number, :notes
  json.url contact_url(contact, format: :json)
end
