class AppTypeToLoffers < ActiveRecord::Migration[5.0]
  def change
    add_column :likely_application_offers, :application_type, :string
  end
end
