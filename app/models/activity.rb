class Activity < ActiveRecord::Base
  belongs_to :event
  has_many :shifts

  validates :name, presence: true
  validates :date, presence: true
end
