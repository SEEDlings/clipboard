class Shift < ActiveRecord::Base
  belongs_to :volunteer
  belongs_to :activity
end
