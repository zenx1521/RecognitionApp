class SessionAttachment < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :points, dependent: :destroy
  belongs_to :session

  before_save :update_image_attributes

  private

  def update_image_attributes
    if image.present?

      self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)
      # if you also need to store the original filename:
      # self.original_filename = image.file.filename
    end
  end
end
