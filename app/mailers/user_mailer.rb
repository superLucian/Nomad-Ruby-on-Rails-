class UserMailer < ActionMailer::Base
  default from: 'Nomad Credit <CEO@nomadcredit.com>'
  add_template_helper(ApplicationHelper)

  def welcome(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Nomad Credit")
  end

  def contact_message(message)
  	@message = message
  	mail(to: "nathan@nomadcredit.com", subject: "New Contact Us Message")
  end

  def signup_success(email)
    if ["ceo@nomadcredit.com","Nathan@nomadcredit.com","help@nomadcredit.com","meetunifi@gmail.com","n.w.treadwell@gmail.com","will2208t@gmail.com"].include?(email) || email.include?("brad.puder") 
      @ga_campaign = "signup_success"
    	mail(to: email, subject: "Thank You for Choosing Nomad Credit – How Can I Help?")
    end
  end

  def finish_search(email, application_type)
    if ["ceo@nomadcredit.com","Nathan@nomadcredit.com","help@nomadcredit.com","meetunifi@gmail.com","n.w.treadwell@gmail.com","will2208t@gmail.com"].include?(email) || email.include?("brad.puder") 
      @application_type = application_type
      @ga_campaign = "finish_search_#{application_type}"
      mail(to: email, subject: "Complete Your #{application_type.titleize} Search")
    end
  end
end
