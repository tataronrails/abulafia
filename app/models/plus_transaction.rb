class PlusTransaction < ActiveRecord::Base
  attr_accessible :desc, :source_user, :value
  default_scope :order => 'created_at DESC'

  has_many :minus_transactions
end
