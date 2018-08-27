class CreateOfferRules < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_rules do |t|
      t.string :attribute_name
      t.text :criteria
      t.belongs_to :offer_rule_set
    end
    create_table :offer_rule_sets do |t|
      t.belongs_to :offer
    end
  end
end
