class Application < ApplicationRecord
  belongs_to :user
  nilify_blanks

  serialize :reason_for_loan, Array

  after_create :stop_drip_campaigns

  before_save :sanitize_params
  # after_save :find_offers
  # after_save :update_status

  has_many :offers, through: :application_offers
  has_many :application_offers


  def sanitize_params
    self.reason_for_loan = self.reason_for_loan.split(",") if (self.reason_for_loan  && self.reason_for_loan.is_a?(String))
    # cosigner = self.has_cosigner == true || self.has_cosigner == "yes"
    # self.has_cosigner = cosigner.to_s
    if self.referral_source.nil? && self.user && self.user.referral_source
      self.referral_source = self.user.referral_source
    end
  end

  def stop_drip_campaigns
    SentEmail.where(email: self.email).each do |se|
      se.disabled = true
      se.save!
    end
  end

  def adjust_pricing(params)
    if params["application"]["volume"] && params["application"]["volume"] != ""
      self.volume = ('%.2f' % params["application"]["volume"].gsub(/\.\d+/,"").gsub(/\D/,"")).to_f
    end
    if params["application"]["annual_income"] && params["application"]["annual_income"] != ""
      self.annual_income = ('%.2f' % params["application"]["annual_income"].gsub(/\.\d+/,"").gsub(/\D/,"")).to_f
    end
    if params["application"]["monthly_housing_payment"] && params["application"]["monthly_housing_payment"] != ""
      self.monthly_housing_payment = ('%.2f' % params["application"]["monthly_housing_payment"].gsub(/\.\d+/,"").gsub(/\D/,"")).to_f
    end
    if params["application"]["outstanding_debts"] && params["application"]["outstanding_debts"] != ""
      self.outstanding_debts = ('%.2f' % params["application"]["outstanding_debts"].gsub(/\.\d+/,"").gsub(/\D/,"")).to_f
    end             
  end

  def editable?
    ["preview", "pending", nil, "draft", "offers"].include?(self.status)
  end

  def update_status
    if self.offers.length > 0 && self.status != "offers"
      self.status = "offers"
      self.save
    end
  end


  # Can we have it email them after 24 hours and then every week for 3 months until they submit? Would want to do this if they fill out at least the first step of any application and click next. We would probably need a trigger to stop the emails from the customer I'm guessing to apply with email laws.

  def self.send_reminder_emails
    preview_applications = Application.where(status: 'preview')
    preview_applications.each do |app|
      if app.reminder_emails_count.nil? || app.reminder_emails_count == 0
        hours_ago = (Time.now - app.created_at)/3600
        if hours_ago >= 24
          ApplicationMailer.application_not_submitted(app).deliver
          app.last_reminder_email_sent = Time.now
          app.reminder_emails_count = 1
          app.save
        end
      else
        days_ago = (Time.now - app.last_reminder_email_sent)/3600/24
        if days_ago >= 7 && days_ago <= 90
          ApplicationMailer.application_not_submitted(app).deliver
          app.last_reminder_email_sent = Time.now
          app.reminder_emails_count += 1
          app.save        
        end
      end
    end
  end


  def find_offers
    ApplicationOffer.where(application_id: self.id).destroy_all
    #find offer_rules that correpond to application_type
    offer_rules = OfferRule.where(criteria: self.application_type)
    #find offer_rule_sets for those offer_rules
    offer_rule_sets = offer_rules.select{ |offer_rule| offer_rule.attribute_name && offer_rule.offer_rule_set && offer_rule.offer_rule_set.enabled }.map { |offer_rule| offer_rule.offer_rule_set }
    offer_rule_sets.each do |ors|
      if ors.offer.enabled
        valid = true
        ors.offer_rules.each do |offer_rule|
          application_value = self.send(offer_rule.attribute_name)
          if offer_rule.criteria.include?("blank") && (application_value.nil? || application_value == "")
            valid = true
            break
          elsif application_value.nil?
            valid = false
            break
          else
            if application_value.is_a?(Numeric)
              valid = eval(application_value.to_s + offer_rule.criteria.to_s)
              break if !valid
            elsif application_value.is_a?(Date)
              if /(<|>|(<=)|(>=)|(==)|(!=)) *\d{4}\-\d{2}\-\d{2}/.match(offer_rule.criteria)
                operator = offer_rule.criteria.split(/\d{4}\-\d{2}\-\d{2}/)[0]
                date = offer_rule.criteria.scan(/\d{4}\-\d{2}\-\d{2}/)[0].to_date
                eval("application_value #{operator} date")                   
              else
                valid = false
                break
              end
            else
              puts offer_rule.criteria.split(",").include?(application_value.to_s)
              if !offer_rule.criteria.split(",").include?(application_value.to_s)
                valid = false
                break
              end
            end
          end
        end
        if valid
          ApplicationOffer.create(offer_id: ors.offer_id, application_id: self.id)
        end
      end
    end
    self.update_status
  end

  def find_likely_offers
    LikelyApplicationOffer.where(user: self.user_id).destroy_all
    offer_rules = OfferRule.where("criteria != '#{self.application_type}'")
    offer_rules.select { |offer_rule| offer_rule.offer_rule_set && !self.user.offers.map(&:id).include?(offer_rule.offer_rule_set.offer_id) }
    
    offer_rule_sets = offer_rules.select{ |offer_rule| offer_rule.attribute_name && offer_rule.offer_rule_set && offer_rule.offer_rule_set.enabled }.map { |offer_rule| offer_rule.offer_rule_set }
    offer_rule_sets.each do |ors|
      if ors.offer.enabled
        valid = true
        ors.offer_rules.each do |offer_rule|
          next if offer_rule.attribute_name == "application_type"
          application_value = self.send(offer_rule.attribute_name)
          if offer_rule.criteria.include?("blank") && (application_value.nil? || application_value == "")
            valid = true
            break
          elsif application_value.nil?
            valid = false
            break
          else
            if application_value.is_a?(Numeric)
              valid = eval(application_value.to_s + offer_rule.criteria.to_s)
              break if !valid
            elsif application_value.is_a?(Date)
              if /(<|>|(<=)|(>=)|(==)|(!=)) *\d{4}\-\d{2}\-\d{2}/.match(offer_rule.criteria)
                operator = offer_rule.criteria.split(/\d{4}\-\d{2}\-\d{2}/)[0]
                date = offer_rule.criteria.scan(/\d{4}\-\d{2}\-\d{2}/)[0].to_date
                eval("application_value #{operator} date")                 
              else
                valid = false
                break
              end
            else
              puts offer_rule.criteria.split(",").include?(application_value.to_s)
              if !offer_rule.criteria.split(",").include?(application_value.to_s)
                valid = false
                break
              end
            end
          end
        end
        if valid && LikelyApplicationOffer.find_by(user_id: self.user_id, offer_id: ors.offer_id).nil? && !self.user.offers.map(&:id).include?(ors.offer_id)
          LikelyApplicationOffer.create(offer_id: ors.offer_id, user_id: self.user_id, application_id: self.id, application_type: ors.application_type)
        end
      end
    end
  end
end