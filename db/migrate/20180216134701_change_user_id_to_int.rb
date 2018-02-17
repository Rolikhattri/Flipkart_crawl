class ChangeUserIdToInt < ActiveRecord::Migration
  def change
  	change_column :products, :user_id, :integer
  end
end
