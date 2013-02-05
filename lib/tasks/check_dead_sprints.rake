desc "Check for outdated sprints with tasks. Move tasks to new sprints and add * to title. Useful with cron."
task :check_dead_sprints => :environment do
  Sprint.check_dead_sprints
end
