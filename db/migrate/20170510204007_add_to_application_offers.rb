class AddToApplicationOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :application_offers, :click_count, :integer, default: 0
    add_column :application_offers, :last_clicked_at, :datetime
  end
end
