class Volunteer < ActiveRecord::Base
  has_many :shifts

  validates :name_last, presence: true
  validates :email, presence: true
  validates_email_format_of :email
end
