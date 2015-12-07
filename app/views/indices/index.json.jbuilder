json.array!(@indices) do |index|
  json.extract! index, :id, :zip
  json.url index_url(index, format: :json)
end
