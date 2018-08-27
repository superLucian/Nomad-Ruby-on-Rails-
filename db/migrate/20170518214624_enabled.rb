class Enabled < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :enabled, :boolean, default: true
    add_column :offer_rule_sets, :enabled, :boolean, default: true
  end
end
