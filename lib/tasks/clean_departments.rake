desc "Make all projects not departments"
task :add_discussions => :environment do
  Project.all.each do |p|
    p p.update_attribute(:is_departments, false)
  end
end
