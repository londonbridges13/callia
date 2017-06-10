json.array!(@recurring_shifts) do |recurring_shift|
  json.extract! recurring_shift, :id, :frequency, :time_span
  json.url recurring_shift_url(recurring_shift, format: :json)
end
