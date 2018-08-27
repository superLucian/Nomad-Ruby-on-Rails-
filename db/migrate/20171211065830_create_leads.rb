class CreateLeads < ActiveRecord::Migration[5.0]
  def change
    create_table :leads do |t|
    	t.string :email
    	t.string :referral_source
    	t.timestamps
    end
  end
end
