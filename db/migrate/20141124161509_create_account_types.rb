class CreateAccountTypes < ActiveRecord::Migration
  def change
    create_table :account_types do |t|

      t.timestamps
    end
  end
end
