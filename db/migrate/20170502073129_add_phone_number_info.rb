class AddPhoneNumberInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :phone_country_code, :string
    add_column :applications, :cosigner_phone_country_code, :string
  end
end
