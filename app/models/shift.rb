class Shift < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :activity

  validates :date, presence: true
  validates :hours, presence: true
  validates :status, presence: true
end
