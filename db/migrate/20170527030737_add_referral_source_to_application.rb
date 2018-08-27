class AddReferralSourceToApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :referral_source, :string
  end
end
