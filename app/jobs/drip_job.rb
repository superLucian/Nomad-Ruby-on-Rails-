class DripJob
  @queue = :drip

  def self.perform(params={})
  	if ENV["STAGING"] == 'true' || Rails.env.development?

  		if params["category"] == "signup_success"
	  		sent_emails = SentEmail.where(category: "signup_success").where(
		 		"(last_sent_at < ? AND count = 1 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 2 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 3 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 4 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 5 AND disabled = FALSE) OR
				(last_sent_at < ? AND count > 5 AND disabled = FALSE)",
				(Time.zone.now - 20.minutes),
				(Time.zone.now - 72.minutes),
				(Time.zone.now - 168.minutes),
				(Time.zone.now - 336.minutes),
				(Time.zone.now - 672.minutes),
				(Time.zone.now - 720.minutes)
			)
	  	else
		 	sent_emails = SentEmail.where("category like 'finish_search%'").where(
		 		"(last_sent_at < ? AND count = 0 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 1 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 2 AND disabled = FALSE)",
				(Time.zone.now - 1.minutes),
				(Time.zone.now - 48.minutes),
				(Time.zone.now - 120.minutes)		 		
		 	)
	  	end


	else

  		if params["category"] == "signup_success"
		 	sent_emails = SentEmail.where(category: "signup_success").where(
		 		"(last_sent_at < ? AND count = 1 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 2 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 3 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 4 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 5 AND disabled = FALSE) OR
				(last_sent_at < ? AND count > 5 AND disabled = FALSE)",
				(Time.zone.now - 20.hours),
				(Time.zone.now - 72.hours),
				(Time.zone.now - 7.days),
				(Time.zone.now - 14.days),
				(Time.zone.now - 28.days),
				(Time.zone.now - 30.days)
			)
		 else
		 	sent_emails = SentEmail.where("category like 'finish_search%'").where(
		 		"(last_sent_at < ? AND count = 0 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 1 AND disabled = FALSE) OR
				(last_sent_at < ? AND count = 2 AND disabled = FALSE)",
				(Time.zone.now - 1.hours),
				(Time.zone.now - 48.hours),
				(Time.zone.now - 5.days)		 		
		 	)
		 end


	end

 	sent_emails.each do |email|
 		Resque.enqueue(EmailJob, {email: email.email, category: email.category})
 	end
  end
end