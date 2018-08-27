class CreateOfferClicks < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_clicks do |t|
      t.integer :offer_id
      t.integer :click_count
      t.datetime :last_clicked_at
      t.boolean :likely
      t.integer :application_offer_id
      t.integer :user_id
    end
  end
end
