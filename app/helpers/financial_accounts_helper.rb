module FinancialAccountsHelper
  
  def getAccountname(account_id)
    @account_type = AccountType.find(account_id).name
  end
  
  
  def test 
    connection = ActiveRecord::Base.connection
    @users = connection.execute("select sum(balance) as balance , sum(actual_payment) as actual_payment, sum(min_payment) as min_payment, sum(original_balance) as original_balance from  financial_accounts where user_id = #{current_user.id}")   
    @users.each(:as => :hash) do |row| 
   abort((row).inspect)
end
    
    abort(@users.first[0].inspect)
  end
end
