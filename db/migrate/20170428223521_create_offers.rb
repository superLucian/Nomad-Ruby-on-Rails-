class CreateOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :offers do |t|
      t.string :company_name
      t.string :apr_range
      t.string :fees
      t.text :borrower_protections
      t.text :amounts_available
    end
  end
end
