class Volunteer < ActiveRecord::Base
  has_many :shifts

  # validates :name_first, presence: true
  validates :name_last, presence: true
  validates :email, presence: true, uniqueness: true
end
