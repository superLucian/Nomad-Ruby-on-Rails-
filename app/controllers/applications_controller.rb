class ApplicationsController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_application, except: [:new, :offer_clicked, :create, :update, :create_interest]

  def show
    if current_user.sign_in_count <= 1
      redirect_to new_application_path(current_user.application_type)
    end
  end

  def new
    applications = current_user.applications.where(application_type: params[:application_type])
    if applications.length > 0
      redirect_to dashboard_path
    end
    apps = applications.last(3)
    first_app = apps.shift
    new_app = first_app
    apps.each do |app|
      new_app = Application.new(new_app.attributes.merge(app.attributes.select { |k,v| v }))
    end
    @application = new_app || Application.new
    @application.id = nil
    ApplicationStart.create(user_id: current_user.id, application_type: params[:application_type])
    @application.application_type = params[:application_type] || 'student_loan'
  end

  def create
    # binding.pry
    application = Application.new(application_params)
    application.adjust_pricing(params)
    if application_params["dob"]
      split = application_params["dob"].split("/")
      application.dob = Date.new(split[2].to_i, split[0].to_i, split[1].to_i)
    end
    application.user_id = current_user.id
    application.status = 'preview'
    application.save
    redirect_to preview_path(application) + "?application_type=#{application.application_type}"
  end

  def edit
    @application = Application.find(params[:id])

    if @application.status == 'submitted'
      redirect_to dashboard_path
    end
  end

  def update
    @application = Application.find(params[:id])
    @application.assign_attributes(application_params)
    if application_params["dob"]
      split = application_params["dob"].split("/")
      @application.dob = Date.new(split[2].to_i, split[0].to_i, split[1].to_i)
    end
    @application.adjust_pricing(params)    
    @application.save
    redirect_to preview_path(@application.id) + "?application_type=#{@application.application_type}"
  end

  def preview
    if !current_user
      redirect_to new_user_session_path
    end
    @application = Application.find(params[:id])    

    if @application.status == 'submitted'
      redirect_to dashboard_path
    end
  end

  def confirm
    @application = Application.find(params[:id])
    @application.find_offers
    @application.find_likely_offers

    if @application.offers.length > 0
      @application.status = 'offers'
    else
      @application.status = 'submitted'
    end
    @application.save

    ApplicationMailer.application_submitted(@application).deliver
    redirect_to offers_path(@application.id)
  end

  def create_interest
    Interest.create(user_id: current_user.id, category: params["interest"])
    if params["interest"] == "OFX"
      redirect_to "https://www.ofx.com/en-us/p/nomad?pid=5378"
    else
      redirect_to dashboard_path, notice: "Thanks! We'll be in touch once mortgages become available."
    end
  end

  def offers
    @application = Application.find(params[:id])
    @application_offers = @application.application_offers.sort_by { |a| a.offer_id }
    @likely_offers = {}
    likely_offers = LikelyApplicationOffer.where(user_id: @application.user_id).sort_by { |a| a.offer_id }
    application_types = likely_offers.map(&:application_type).uniq
    likely_offer_ids = likely_offers.map(&:offer_id)
    likely_offers.each do |likely_offer|
      if @likely_offers[likely_offer.application_type]
        @likely_offers[likely_offer.application_type] << likely_offer
      else
        @likely_offers[likely_offer.application_type] = [likely_offer]
      end
    end
    @likely_offers = @likely_offers.sort_by { |application_type, offers| application_type_priority(application_type)}.to_h  
    if @application_offers.length == 0 && !request.url.include?("?")
      redirect_to offers_path + "?none=true&application_type=#{@application.application_type}"
    elsif @application_offers.length > 0 && !request.url.include?("?")
      redirect_to offers_path + "?none=false&application_type=#{@application.application_type}"
    end

  end




  def offer_clicked
    offer = OfferClick.find_or_create_by(
      offer_id: params[:offer_id], 
      user_id: current_user.id, 
      likely: params[:likely],
      application_id: params[:id]
    )

    if offer
      offer.click_count = 0 if offer.click_count.nil?
      offer.click_count += 1
      offer.last_clicked_at = Time.now
      offer.save
      redirect_to Offer.find(params[:offer_id]).url
    else
      if params[:likely]
        redirect_to "/options"
      else
        redirect_to "/applications/#{params[:id]}/offers"
      end
    end
  end

  private 

  def authenticate_user
    if current_user.nil? 
      redirect_to new_user_session_path
    end
  end

  def authenticate_application
    app = Application.find_by(id: params[:id])
    if app.nil? || app.user_id != current_user.id
      redirect_to new_user_session_path
    end
  end

  def application_params
    params.require(:application).permit(:school, :period, :degree_type, :visa_type, :year_in_school, :expected_graduation, :employment_status, :employer, :volume, :annual_income, :annual_income_others, :monthly_housing_payment, :citizenship_status, :dob, :phone_number, :current_street_address, :current_postal_code, :current_city, :current_state, :current_country, :home_street_address, :home_postal_code, :home_city, :home_state, :home_country, :application_type, :first_name, :last_name, :email, :accepted_terms, :has_cosigner, :cosigner_first_name, :cosigner_last_name, :cosigner_email, :cosigner_phone_number, :outstanding_debts, :housing_type, :cosigner_country, :credit_score, :application_type, :visa_type, :reason_for_loan_personal,:phone_country_code, :cosigner_phone_country_code, {:reason_for_loan => []} )
  end
end