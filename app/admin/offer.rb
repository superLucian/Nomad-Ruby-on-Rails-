ActiveAdmin.register Offer do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :company_name, :apr_range, :fees, :borrower_protections, :amounts_available, :logo_file_name,:logo_content_type,:logo_file_size,:logo_updated_at, :logo, :url, :enabled, :description
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  form do |f|
    inputs 'Offer', :multipart => true do
      input :company_name
      input :apr_range
      input :fees
      input :borrower_protections
      input :amounts_available, label: "Loan terms and amounts available"
      input :logo, as: :file, :hint => f.object.logo.present? \
      ? image_tag(f.object.logo.url(:medium))
      : content_tag(:span, "no logo yet")
      input :url
      input :description
      input :enabled
      actions
    end
  end

end
