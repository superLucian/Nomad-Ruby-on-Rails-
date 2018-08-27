class AddApplicationId < ActiveRecord::Migration[5.0]
  def change
  	add_column :offer_clicks, :application_id, :integer
  end
end
