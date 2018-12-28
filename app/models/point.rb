class Point < ApplicationRecord
  belongs_to :session_attachment
  has_many :marks, dependent: :destroy
end
