class AddNameToAccountType < ActiveRecord::Migration
  def change
    add_column :account_types, :name, :string
  end
end
