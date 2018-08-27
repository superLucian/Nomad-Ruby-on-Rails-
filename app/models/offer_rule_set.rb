class OfferRuleSet < ApplicationRecord
  belongs_to :offer
  has_many :offer_rules
  nilify_blanks

  accepts_nested_attributes_for :offer_rules, :allow_destroy => true

  def application_type
    rule = self.offer_rules.find_by(attribute_name: "application_type")
    rule && rule.criteria
  end

end