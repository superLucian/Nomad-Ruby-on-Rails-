class AddReferralToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :referral_source, :string
  end
end
