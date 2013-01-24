class Sprint < ActiveRecord::Base
  belongs_to :project
  attr_accessible :desc, :end_at, :start_at
end
