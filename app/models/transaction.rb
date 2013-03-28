class Transaction < ActiveRecord::Base
  belongs_to :from_account, :class_name => Account
  belongs_to :to_account, :class_name => Account
  belongs_to :author
  attr_accessible :desc, :value, :status, :from_account_id, :to_account_id

  validates :from_account, :to_account, :author, :value, presence: true
  validates :value, :numericality => {:greater_than => 0}

  validate :from_account_balance, :on => :create
  def from_account_balance
    if self.from_account.present? && !self.from_account.is_system_accout? &&
                                      self.from_account.andand.balance < value
      errors.add :from_account, :account_balance_is_low
    end
  end

  validate :accounts_differences, :on => :create
  def accounts_differences
    if self.from_account.present? && self.to_account.present? &&
        self.from_account.eql?(self.to_account)
      errors.add :from_account, :from_account_eql_to_account
    end
  end

  has_ancestry
end
