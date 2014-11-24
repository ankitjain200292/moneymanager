json.array!(@account_types) do |account_type|
  json.extract! account_type, :id
  json.url account_type_url(account_type, format: :json)
end
