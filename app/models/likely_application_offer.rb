class LikelyApplicationOffer < ApplicationRecord
  belongs_to :application
  belongs_to :user
  belongs_to :offer
end