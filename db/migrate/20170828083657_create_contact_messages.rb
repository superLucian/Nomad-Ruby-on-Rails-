class CreateContactMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_messages do |t|
		t.string :first_name
		t.string :last_name
		t.string :email_address
		t.string :phone_number
		t.string :product
		t.text :message
    end
  end
end
