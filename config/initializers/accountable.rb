require File.join(Rails.root, "lib/transactions/accountable")
ActiveRecord::Base.send :include, Accountable