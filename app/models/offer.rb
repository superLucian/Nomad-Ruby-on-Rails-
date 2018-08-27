class Offer < ApplicationRecord
  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "original/missing.png"
  validates_attachment_content_type :logo, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

end