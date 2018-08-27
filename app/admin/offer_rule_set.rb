ActiveAdmin.register OfferRuleSet do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :offer_id, :set_description, {:offer_rule => [:attribute_name,:criteria]}
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  controller do
    def create
      ors = OfferRuleSet.create(offer_id: params["offer_rule_set"]["offer_id"], set_description: params["offer_rule_set"]["set_description"])
      params["offer_rule_set"]["offer_rules_attributes"].values.each do |o|
        if o["attribute_name"] && o["attribute_name"] != ""
          OfferRule.create(attribute_name: o["attribute_name"], criteria: o["criteria"], offer_rule_set_id: ors.id)
        end
      end
      redirect_to '/admin/offer_rule_sets'
    end

    def update
      ors = OfferRuleSet.find(params["id"])
      ors.update(set_description: params["offer_rule_set"]["set_description"], offer_id: params["offer_rule_set"]["offer_id"])
      ors.offer_rules.destroy_all
      params["offer_rule_set"]["offer_rules_attributes"].values.each do |o|
        if o["attribute_name"] && o["attribute_name"] != ""
          OfferRule.create(attribute_name: o["attribute_name"], criteria: o["criteria"], offer_rule_set_id: ors.id)
        end
      end
      redirect_to '/admin/offer_rule_sets'
    end
  end

  index do
    id_column
    column "Company" do |offer_rule_set|
      offer_rule_set.offer && offer_rule_set.offer.company_name
    end
    column :set_description
    column "Columns Affected" do |offer_rule_set|
      offer_rule_set.offer_rules.map { |o| o.attribute_name }.join(" | ")
    end
    actions
  end

  form do |f|
    f.inputs do
      f.has_many :offer_rules do |r|
        r.input :attribute_name, as: :select, collection: Application.column_names.sort
        r.input :criteria, hint: 'For non-numeric values, should be a comma-separated list of acceptable values. This list IS case-sensitive, and there should be no spacing before or after commas (e.g. for home_country, criteria might be: India,United Kindgom,China). For numeric values, use an operator and then a number (with no symbols or commas). Operators are: >, >= (greater than or equal to), <, <=, != (does not equal), == (equals) (e.g. >= 30000 ). For numbers between X and Y, use two rules: >=X and <=Y for the same column name.'
      end
    end
    f.inputs 'Set Attributes' do
      f.input :offer_id, as: :select, collection: Offer.all.map { |c| ["#{c.company_name} - ID: #{c.id}", c.id]}
      f.input :set_description
      f.input :enabled
    end
    f.actions
  end

end
