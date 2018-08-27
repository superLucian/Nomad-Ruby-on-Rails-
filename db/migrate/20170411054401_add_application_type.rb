class AddApplicationType < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :application_type, :string
    change_column :applications, :expected_graduation, :string
  end
end
