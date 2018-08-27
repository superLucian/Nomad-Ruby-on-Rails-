require 'sso'

class ApplicationController < ActionController::Base
  include ApplicationHelper
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_referral_cookie
  before_action :handle_confirmation
  before_action :persist_login_param


  protected

  def persist_login_param
    if request.path == '/users/sign_in' && request.get? && request.query_string != "" && !request.query_string.include?("confirm")
      session[:query_string] = request.query_string
      if (cookies[:referral_source].nil? || cookies[:referral_source] == "")
        cookies[:referral_source] = { value: "forum", expires: 1.year.from_now }
      end
    end
  end

  def handle_confirmation
    return unless request.get?
    if session[:previous_url] && session[:previous_url].include?("confirmation_token")
      session[:previous_url] = request.fullpath
      redirect_to request.fullpath + "?confirmed=true"
    else
      session[:previous_url] = request.fullpath
    end
  end

  def set_referral_cookie
    if params[:referral_source] && (cookies[:referral_source].nil? || cookies[:referral_source] == "")
      cookies[:referral_source] = { value: params[:referral_source], expires: 1.year.from_now }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:country, :first_name, :last_name, :application_type, :referral_source, :promo_code, :username, :terms_of_service])
  end

  def after_sign_in_path_for(resource_or_scope)
    resource = resource_or_scope
    q = session[:query_string] || request.query_string
    if resource && resource.is_a?(AdminUser)
      return admin_dashboard_path

    elsif resource && q && q != "" && !q.include?("confirm")
      secret = "0106a4bc558721040781023c2d3de4a2"
      sso = SingleSignOn.parse(q, secret)
      if sso
        sso.email = resource.email
        sso.name = "#{resource.first_name} #{resource.last_name}"
        sso.username = "#{resource.username}"
        sso.external_id = "#{resource.id}" # unique id for each user of your application
        sso.sso_secret = secret
        session[:query_string] = nil
        sso.to_url("https://discuss.nomadcredit.com/session/sso_login")
      else 
        session[:query_string] = nil
        dashboard_path
      end
    else 
      if resource && resource.is_a?(AdminUser)
        admin_dashboard_path
      else
        if resource && resource.application_type
          app = Application.find_by(user_id: resource.id, application_type: resource.application_type)
          if app.nil?
            "/applications/#{resource.application_type}/new"
          elsif app.status == "draft" || app.status == "preview"
            edit_application_path(app.id)
          else
            dashboard_path
          end
        else
          "/applications/student_loan/new"
        end
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    resource = resource_or_scope
    if resource.is_a?(AdminUser)
      new_admin_user_session_path
    else
      new_user_session_path
    end
  end


  def after_sign_up_path_for(resource)
    if resource.is_a?(AdminUser)
      new_admin_user_session_path
    else
      new_user_session_path
    end
  end


  def after_inactive_sign_up_path_for(resource)
    if resource.is_a?(AdminUser)
      new_admin_user_session_path
    else
      new_user_session_path
    end
  end

end
