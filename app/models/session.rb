class Session < ApplicationRecord
  belongs_to :user
  has_many :session_attachments, dependent: :destroy, inverse_of: :session
  has_many :checkboxs, dependent: :destroy
  has_many :session_statuses, dependent: :destroy
  accepts_nested_attributes_for :session_attachments, allow_destroy: true
  validates :title, presence: true
  validates :description, presence: true
  validate :validate_session_attachments_presence

  def to_param
    token
  end

  private

  def validate_session_attachments_presence
    if session_attachments.reject(&:marked_for_destruction?).blank?
      errors.add(:session_attachments,"At least one image must be added.")
    end
  end
end
