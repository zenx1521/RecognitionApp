class Session < ApplicationRecord
  belongs_to :user
  has_many :session_attachments, dependent: :destroy
  has_many :checkboxs, dependent: :destroy
  has_many :session_statuses, dependent: :destroy
  accepts_nested_attributes_for :session_attachments
  #validates_length_of :session_attachments, minimum: 1 , :message => ": Please choose at least one photo"
  #validates :session_attachments, presence: true

  def to_param
    token
  end
end
