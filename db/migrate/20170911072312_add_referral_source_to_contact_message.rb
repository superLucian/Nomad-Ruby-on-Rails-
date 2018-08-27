class AddReferralSourceToContactMessage < ActiveRecord::Migration[5.0]
  def change
  	add_column :contact_messages, :referral_source, :string
  end
end
