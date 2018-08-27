class User < ApplicationRecord
  nilify_blanks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email
  validates_uniqueness_of :username, :allow_nil => true, :allow_blank => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :applications
  has_many :application_starts

  before_save :send_welcome_email
  after_create :destroy_lead

  require 'sendgrid-ruby'
  include SendGrid


  validates :terms_of_service, acceptance: true

  def destroy_lead
    Lead.where(email: self.email).destroy_all
  end

  def send_welcome_email
    if self.confirmed_at_was.nil? && !self.confirmed_at.nil?
      UserMailer.welcome(self).deliver_now
    end
  end

  def application_button(application_type, user)
    application = Application.where(user_id: user.id, application_type: application_type).last
    if application
      if application.status == "offers"
        return ["View Options", "/applications/#{application.id}/offers"]        
      elsif application.editable?
        return ["Continue Search", "/applications/#{application.id}/edit"]
      else
        return ["Search Now", "/applications/#{application_type}/new"]
      end
    else
      return ["Search Now", "/applications/#{application_type}/new"]
    end
  end

  def offers
    self.applications.map(&:offers).flatten
  end

  def self.update_sendgrid_contacts
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    body = []
    User.all.each do |user|
      user_body = { "first_name" => user.first_name, "last_name" => user.last_name, "email" => user.email }
      offers_presented = ""
      offers_selected = ""
      #offers presented
      user.offers.each { |o| offers_presented += "#{o.company_name}_#{o.id},"}
      #offers selected
      OfferClick.where("user_id=#{user.id} and click_count > 0").each do |oc| 
        offers_selected += ("#{oc.offer && oc.offer.company_name}_#{oc.offer_id},")
      end
      user.applications.each do |application|
        user_body["#{application.application_type}"] = "true"
      end

      user.application_starts.each do |application_start|
        user_body["#{application_start.application_type}_started"] = "true"
      end

      if user.applications.length > 0
        user_body["home_country"]  = user.applications.first.home_country
      end
      # body << user_body
      user_body["source"] = "signup"
      if user.referral_source
        user_body["referral_source"] = user.referral_source 
      end   
      user_body["offers_presented"] = offers_presented
      user_body["offers_selected"] = offers_selected
      body << user_body
    end
    Lead.all.each do |lead|
      user_body = {"email" => lead.email, "source" => "signup", "lead" => "true"}
      if lead.referral_source
        user_body["referral_source"] = lead.referral_source 
      end
      body << user_body             
    end
    sg.client.contactdb.recipients.post(request_body: body)
  end

  def self.trigger_drip_campaigns
    Resque.enqueue(DripJob, { category: "signup_success" })
    Resque.enqueue(DripJob, { category: "finish_search" })
  end


  private
  # def confirmation_required?
  #   false
  # end
end
