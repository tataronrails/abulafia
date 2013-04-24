class GenerateAccounts < ActiveRecord::Migration
  def up
    Project.all.each do |project|
      project.create_account unless project.account.present?
    end
    User.all.each do |user|
      user.create_account unless user.account.present?
    end
    Sprint.all.each do |sprint|
      sprint.create_account unless sprint.account.present?
    end
  end

  def down
  end
end
