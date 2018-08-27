class CreateInterests < ActiveRecord::Migration[5.0]
  def change
    create_table :interests do |t|
      t.references :user
      t.string :category
      t.timestamps
    end
  end
end
