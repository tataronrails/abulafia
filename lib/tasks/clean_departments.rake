desc "Make all projects not departments"
task :clean_deps => :environment do
  Project.all.each do |p|
    p p.update_attribute(:is_department, false)
  end
end
