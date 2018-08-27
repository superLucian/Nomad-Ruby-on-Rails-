class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.belongs_to :user
      t.string  :school
      t.string  :period
      t.string  :degree_type
      t.string  :visa_type
      t.string  :year_in_school
      t.date    :expected_graduation
      t.string  :employment_status
      t.string  :employer
      t.integer :volume
      t.float   :annual_income
      t.float   :annual_income_others
      t.float   :monthly_housing_payment
      t.string  :citizenship_status
      t.date    :dob
      t.string  :phone_number
      t.string  :current_street_address
      t.string  :current_postal_code
      t.string  :current_city
      t.string  :current_state
      t.string  :current_country
      t.string  :home_street_address
      t.string  :home_postal_code
      t.string  :home_city
      t.string  :home_state
      t.string  :home_country      
      t.string  :application_type
      t.string  :first_name
      t.string  :last_name
      t.string  :email  
      t.boolean :accepted_terms
      t.string :has_cosigner
      t.string  :cosigner_first_name
      t.string  :cosigner_last_name
      t.string  :cosigner_email
      t.string  :cosigner_phone_number
      t.text    :reason_for_loan
      t.string  :outstanding_debts   
      t.string  :housing_type   
      t.timestamps
    end
  end
end
