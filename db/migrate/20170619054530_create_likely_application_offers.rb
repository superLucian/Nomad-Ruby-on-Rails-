class CreateLikelyApplicationOffers < ActiveRecord::Migration[5.0]
  def change
    create_table :likely_application_offers do |t|
      t.integer :click_count, default: 0
      t.datetime :last_clicked_at
      t.belongs_to :user
      t.belongs_to :application
      t.belongs_to :offer
    end
  end
end
