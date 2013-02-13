class MinusTransaction < ActiveRecord::Base
  belongs_to :project
  belongs_to :plus_transaction
  attr_accessible :target_user,:value, :plus_transaction_id, :project_id



  default_scope :order => 'created_at DESC'
end
