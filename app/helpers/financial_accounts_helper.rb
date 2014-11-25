module FinancialAccountsHelper
  
  def getAccountname(account_id)
    @account_type = AccountType.find(account_id).name
  end
end
