desc "Add logins to old users"
task :add_logins => :environment do
  User.all.each do |u|
    unless u.login.present?
      u.login = u.email.split("@").first.gsub(/[^0-9A-Za-z]/, '')
      p u.save
    end
  end
end
