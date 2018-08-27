class SentEmail < ApplicationRecord
  nilify_blanks
  belongs_to :user
  belongs_to :lead
  belongs_to :application

  def increment!
  	self.count = self.count + 1
  	self.last_sent_at = Time.zone.now
  	self.save
  end
end