class CreateApplicationOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :application_offers do |t|
      t.belongs_to :application
      t.belongs_to :offer
    end
  end
end
