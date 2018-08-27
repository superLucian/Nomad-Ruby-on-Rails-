class ApplicationStart < ActiveRecord::Base
	belongs_to :user
	nilify_blanks

	after_create :create_sent_email


	def create_sent_email
		sent_email = SentEmail.find_or_create_by(
			user_id: self.user_id,
			category: "finish_search_#{application_type}"
		)

		if sent_email.last_sent_at.nil?
			sent_email.count = 0
			sent_email.email =  self.user.email
			sent_email.last_sent_at = Time.zone.now
		end
	end

end