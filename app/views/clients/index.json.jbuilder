json.array!(@clients) do |client|
  json.extract! client, :id, :name, :client_code, :authorized_phone, :status
  json.url client_url(client, format: :json)
end
