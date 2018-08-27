class CreateSentEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_emails do |t|
    	t.belongs_to :user
    	t.belongs_to :lead
    	t.belongs_to :application
    	t.string :category
    	t.integer :count, default: 0
    	t.datetime :last_sent_at
        t.string :email
    	t.timestamps
    end
  end
end
