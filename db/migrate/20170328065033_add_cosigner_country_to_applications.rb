class AddCosignerCountryToApplications < ActiveRecord::Migration::Current
  def change
    add_column :applications, :cosigner_country, :string
    add_column :applications, :credit_score, :string
    remove_column :applications, :application_type, :string
    add_column :applications, :application_type, :string, default: 'student_loan'
    add_column :applications, :status, :string
  end
end
