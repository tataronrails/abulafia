# encoding: UTF-8
module Accountable
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_accountable options={}

      class_eval do
        after_create :assign_account

        has_one :account, :as => :owner, :dependent => :destroy

      end

      include Accountable::InstanceMethods
    end
  end

  module InstanceMethods

    def balance
      self.account.balance
    end

    def transactions
      self.account.transactions
    end


    private

    def assign_account params = {}
      self.create_account
    end

  end
end