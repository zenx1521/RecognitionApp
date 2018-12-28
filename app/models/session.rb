class Session < ApplicationRecord
  belongs_to :user
  has_many :session_attachments, dependent: :destroy
  has_many :checkboxs, dependent: :destroy
  has_many :session_statuses, dependent: :destroy
  accepts_nested_attributes_for :session_attachments

  def to_param
    token
  end

  def thumbnail
    return self.image.variant(resize: '300x300')
  end
end
