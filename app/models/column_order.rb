class ColumnOrder < ActiveRecord::Base
  attr_accessible :positions, :project

  serialize :positions, Array
end
