ActiveAdmin.register Application do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :school, :period, :degree_type, :visa_type, :year_in_school, :expected_graduation, :employment_status, :employer, :volume, :annual_income, :annual_income_others, :monthly_housing_payment, :citizenship_status, :dob, :phone_number, :current_street_address, :current_postal_code, :current_city, :current_state, :current_country, :home_street_address, :home_postal_code, :home_city, :home_state, :home_country, :application_type, :first_name, :last_name, :email, :accepted_terms, :has_cosigner, :cosigner_first_name, :cosigner_last_name, :cosigner_email, :cosigner_phone_number, :outstanding_debts, :housing_type, :cosigner_country, :credit_score, :application_type, :visa_type, :reason_for_loan_personal,:phone_country_code, :cosigner_phone_country_code, {:reason_for_loan => []}
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  filter :first_name
  filter :last_name
  filter :email_address
  filter :referral_source
  filter :application_type
  filter :home_country
  filter :current_country
  filter :school

  batch_action :find_likely_offers do |ids|
    batch_action_collection.find(ids).each do |application|
      application.find_likely_offers
    end
    redirect_to collection_path, alert: "Likely offers updated!"
  end

  batch_action :find_offers do |ids|
    batch_action_collection.find(ids).each do |application|
      application.find_offers
    end
    redirect_to collection_path, alert: "Offers updated!"
  end

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone_number
    column "Email" do |application|
      application.user && application.user.email
    end
    column :school
    column :created_at
    column :application_type
    column :status
    column :created_at
    column :referral_source 
    column "Offer Count" do |application|
      application.offers.count
    end
    column "Offer Clicks" do |application|
      OfferClick.where(application_id: application.id, likely: nil).map(&:click_count).compact.reduce(:+)
    end
    column "User LO Clicks" do |application|
      OfferClick.where(user_id: application.user_id, likely: true).map(&:click_count).compact.reduce(:+)
    end
    column "Offers Presented" do |application|
      offers_presented = ""
      application.offers.each { |o| offers_presented += "#{o.company_name}_#{o.id},"}
      offers_presented
    end
    column "Offers Selected" do |application|
      offers_selected = ""
      OfferClick.where("user_id=#{application.user_id} and click_count > 0 and likely is null").each do |oc| 
        offers_selected += ("#{oc.offer && oc.offer.company_name}_#{oc.offer_id},")
      end
      offers_selected
    end   
    actions
  end

csv do
  Application.column_names.each { |col| column col.to_sym }
  column "Offers Presented" do |application|
    offers_presented = ""
    application.offers.each { |o| offers_presented += "#{o.company_name}_#{o.id},"}
    offers_presented
  end
  column "Offers Selected" do |application|
    offers_selected = ""
    OfferClick.where("user_id=#{application.user_id} and click_count > 0 and likely is null").each do |oc| 
      offers_selected += ("#{oc.offer && oc.offer.company_name}_#{oc.offer_id},")
    end
    offers_selected
  end
  column "Likely Offers Presented" do |application|
    offers_presented = ""
    LikelyApplicationOffer.where(user_id: application.user_id).each { |o| offers_presented += "#{o.offer.company_name}_#{o.offer_id},"}
    offers_presented
  end
  column "Likely Offers Selected" do |application|
    offers_selected = ""
    OfferClick.where("user_id=#{application.user_id} and click_count > 0 and likely is true").each do |oc| 
      offers_selected += ("#{oc.offer && oc.offer.company_name}_#{oc.offer_id},")
    end
    offers_selected
  end        
end

show do
    panel "Offers" do
      attributes_table_for application do
         application.application_offers.each_with_index do |o,i|
            row "offer_#{i+1}" do
              link_to "#{o.offer.company_name} - ID: #{o.offer.id}", "/admin/offers/#{o.offer.id}"
            end
            row "offer_#{i+1} clicks" do
              oc = OfferClick.find_by(offer_id: o.offer_id, user_id: application.user_id, application_id: application.id)              
              oc && oc.click_count
            end
            row "offer_#{i+1} last clicked" do
              oc = OfferClick.find_by(offer_id: o.offer_id, user_id: application.user_id, application_id: application.id)              
              oc && oc.last_clicked_at
            end
         end
      end
    end
    panel "Likely Offers" do
      attributes_table_for application do
         LikelyApplicationOffer.where(user_id: application.user_id).each_with_index do |o,i|
            row "offer_#{i+1}" do
              link_to "#{o.offer.company_name} - ID: #{o.offer.id}", "/admin/offers/#{o.offer.id}"
            end
            row "offer_#{i+1} clicks" do
              oc = OfferClick.find_by(offer_id: o.offer_id, user_id: application.user_id, likely: true)
              oc && oc.click_count
            end
            row "offer_#{i+1} last clicked" do
              oc = OfferClick.find_by(offer_id: o.offer_id, user_id: application.user_id, likely: true)
              oc && oc.last_clicked_at
            end
         end
      end
    end    
    attributes_table do
        Application.column_names.each do |c|
            row c.to_sym
        end
    end
  end
end
