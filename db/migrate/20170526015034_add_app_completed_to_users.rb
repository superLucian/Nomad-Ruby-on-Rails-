class AddAppCompletedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :application_completed, :string, default: true
  end
end
