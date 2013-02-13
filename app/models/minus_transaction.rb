class MinusTransaction < ActiveRecord::Base
  belongs_to :project
  attr_accessible :target_user
end
