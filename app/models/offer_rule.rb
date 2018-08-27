class OfferRule < ApplicationRecord
  belongs_to :offer_rule_set
  nilify_blanks

end