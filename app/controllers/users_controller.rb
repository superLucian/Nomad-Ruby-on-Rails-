class UsersController < ApplicationController
  before_action :authenticate_user

  def show
    if !current_user
      redirect_to "/users/sign_in"
    end
    @user = current_user
    @likely_offers = LikelyApplicationOffer.where(user_id: current_user.id).order(:application_id)
  end

  def likely_offers
    @likely_offers = {}
    likely_offers = LikelyApplicationOffer.where(user_id: current_user.id).sort_by { |a| a.offer_id }
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

  end

  def sign_out_with_discourse
    # discuss sign out
    response = HTTParty.get("https://discuss.nomadcredit.com/users/by-external/#{current_user.id}.json?api_username=brad.p&api_key=c50f3557bccbc957a6cec20e32f40c32ff6b7623d699f384d524f9ce3d1ac9a3").parsed_response 
    if response["users"] and response["users"].length > 0
      response["users"].each do |user|
        HTTParty.post("https://discuss.nomadcredit.com/admin/users/#{user['id']}/log_out?api_username=brad.p&api_key=c50f3557bccbc957a6cec20e32f40c32ff6b7623d699f384d524f9ce3d1ac9a3")
      end
    end
    if params["source"] == "forum"
      Devise.sign_out_all_scopes
      redirect_to "https://discuss.nomadcredit.com/"
    else
      sign_out_and_redirect(current_user)
    end
  end

  def sso
    redirect_to '/users/sign_in?' + request.query_string
  end

  private

  def authenticate_user
    if current_user.nil?
      redirect_to new_user_session_path
    end
  end

end