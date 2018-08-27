class AddUrlToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :url, :text
  end
end
