json.array!(@offices) do |office|
  json.extract! office, :id, :name, :telephone, :office_code
  json.url office_url(office, format: :json)
end
