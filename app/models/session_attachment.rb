class SessionAttachment < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :points, dependent: :destroy
  belongs_to :session, inverse_of: :session_attachments
  before_save :update_image_attributes

  private


  def update_image_attributes
    if image.present?

      self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)

    end
  end
end
