class Lead < ApplicationRecord

	after_create :signup_success

	def signup_success
		Resque.enqueue(EmailJob, {email: self.email, category: "signup_success"})
	end
end