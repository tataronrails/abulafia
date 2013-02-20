class Transaction < ActiveRecord::Base
  belongs_to :from_account, :class_name => Account
  belongs_to :to_account, :class_name => Account
  belongs_to :author
  attr_accessible :desc, :value, :status, :from_account_id, :to_account_id
  has_ancestry
end
