class Event < ActiveRecord::Base
  has_many :activities

  validates :name, presence: true
  validates :date, presence: true
  validates :recurrence, presence: true
end
