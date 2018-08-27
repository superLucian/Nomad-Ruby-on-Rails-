class AddQueryStringToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :query_string, :text
  end
end
