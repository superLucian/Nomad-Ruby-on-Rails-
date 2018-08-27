class LeadsController < ApplicationController

	def create
		Lead.create({email: params["email"], referral_source: params["referral_source"]})
	end

end