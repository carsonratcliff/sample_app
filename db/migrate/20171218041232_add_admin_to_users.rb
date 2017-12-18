class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
  	# 10.54 - Adding Admin attribute
    add_column :users, :admin, :boolean, default: false
  end
end
