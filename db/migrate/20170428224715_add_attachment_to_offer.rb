class AddAttachmentToOffer < ActiveRecord::Migration[5.0]
  def change
    add_attachment :offers, :logo
  end
end
