class ApplicationMailer < ActionMailer::Base
  default from: 'Nomad Credit <nathan@nomadcredit.com>'
  add_template_helper(ApplicationHelper)

  def application_submitted(application)
    @application = application
    @application_type = application.application_type.gsub("_", " ")
    @likely_offers = LikelyApplicationOffer.where(user_id: @application.user_id)
    mail(to: @application.user.email, subject: "Your #{@application_type.capitalize} search was submitted")
  end

  def application_not_submitted(application)
    @application = application
    @application_type = application.application_type && application.application_type.titleize
    mail(to: @application.user.email, subject: "Your #{@application_type.capitalize} search has not been submitted")
  end
end
