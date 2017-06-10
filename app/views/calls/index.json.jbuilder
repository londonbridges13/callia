json.array!(@calls) do |call|
  json.extract! call, :id, :caller_number, :called_number
  json.url call_url(call, format: :json)
end
