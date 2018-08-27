class AddTimestampsToContactMessage < ActiveRecord::Migration[5.0]
  def change
  	add_column :contact_messages, :created_at, :datetime
  	add_column :contact_messages, :updated_at, :datetime
  end
end
