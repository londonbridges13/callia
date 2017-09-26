json.array!(@sections) do |section|
  json.extract! section, :id, :section
  json.url section_url(section, format: :json)
end
