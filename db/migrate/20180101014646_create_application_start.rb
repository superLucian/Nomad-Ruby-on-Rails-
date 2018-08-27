class CreateApplicationStart < ActiveRecord::Migration[5.0]
  def change
    create_table :application_starts do |t|
    	t.belongs_to :user
    	t.string :application_type
    	t.timestamps
    end
  end
end
