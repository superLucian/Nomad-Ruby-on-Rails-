class AddReasonForLoanPersonal < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :reason_for_loan_personal, :text
  end
end
