class AddSetName < ActiveRecord::Migration[5.0]
  def change
    add_column :offer_rule_sets, :set_description, :string
  end
end
