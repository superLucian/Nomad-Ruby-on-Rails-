class AddDisabled < ActiveRecord::Migration[5.0]
  def change
  	add_column :sent_emails, :disabled, :boolean, default: false
  end
end
