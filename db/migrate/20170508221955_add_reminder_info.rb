class AddReminderInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :reminder_emails_count, :integer
    add_column :applications, :last_reminder_email_sent, :datetime

  end
end
