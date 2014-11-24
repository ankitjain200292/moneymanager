json.array!(@financial_accounts) do |financial_account|
  json.extract! financial_account, :id, :user_id, :account_type_id, :company_name, :balance, :original_balance, :rate, :min_payment, :actual_payment
  json.url financial_account_url(financial_account, format: :json)
end
