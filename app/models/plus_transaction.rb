class PlusTransaction < ActiveRecord::Base
  attr_accessible :desc, :source_user, :value
end
