class FinancialAccount < ActiveRecord::Base
  
  belongs_to :user
  validates :user_id,  presence: true, :numericality => {:only_integer => true}
  validates :account_type_id,  presence: true, :numericality => {:only_integer => true}
  validates :company_name, presence: true
  validates :balance, presence: true, :numericality => {:only_integer => true}
  validates :original_balance, presence: true, :numericality => {:only_integer => true}
  validates :rate, presence: true, :numericality => {:only_float => true}
  validates :min_payment, presence: true, :numericality => {:only_integer => true}
  validates :actual_payment, presence: true, :numericality => {:only_integer => true}
  
                     
  
end
