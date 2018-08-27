class EmailJob
  @queue = :email

  def self.perform(params={})
  	sent_email = SentEmail.find_or_create_by(
 		email: params["email"],
 		category: params["category"]
 	)

  	sent_email.increment!

    case params["category"]
    when "signup_success"
    	UserMailer.signup_success(sent_email.email).deliver_now
    else
 		UserMailer.finish_search(sent_email.email, params["category"].split("finish_search_")[1]).deliver_now
    end
  end
end