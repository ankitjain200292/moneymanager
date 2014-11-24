class CreateFinancialAccounts < ActiveRecord::Migration
  def change
    create_table :financial_accounts do |t|
      t.integer :user_id
      t.integer :account_type_id
      t.string :company_name
      t.string :balance
      t.string :original_balance
      t.float :rate
      t.string :min_payment
      t.integer :actual_payment

      t.timestamps
    end
  end
end
