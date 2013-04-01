class Account < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  attr_accessible :title, :kind

  has_many :in_transactions, class_name: Transaction, foreign_key: :to_account_id
  has_many :out_transactions, class_name: Transaction, foreign_key: :from_account_id

  def balance
    self.in_transactions.sum(:value) - self.out_transactions.sum(:value)
  end

  def transactions
    Transaction.where('to_account_id = ? OR from_account_id = ?', id, id)
  end

  def is_system_account?
    self.kind == 'system'
  end

  def owner_name
      if owner.present?
        owner
      else
        title
      end
  end
end
