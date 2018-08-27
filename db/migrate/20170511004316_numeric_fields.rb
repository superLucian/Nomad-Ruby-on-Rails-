class NumericFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :applications, :outstanding_debts, :text
    add_column :applications, :outstanding_debts, :integer
  end
end
