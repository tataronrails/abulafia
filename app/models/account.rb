class Account < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  attr_accessible :title, :owner

  def owner_name
      if owner.present?
        owner
      else
        title
      end
  end
end
