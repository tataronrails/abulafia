class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :tasks
  attr_accessible :desc, :end_at, :start_at, :title

  scope :alive, where{end_at > Time.now}
  scope :dead,  where{end_at < Time.now}
  scope :currents, lambda{ where( 'start_at <= :c_date AND end_at >= :c_date', c_date: Time.now.to_date) }

  before_create :assign_iteration_number

  acts_as_accountable



  def short_desc
    "#{title} (#{I18n.l start_at, format: :short} - #{I18n.l end_at, format: :short})"
  end

  # use in [rake task :check_dead_sprints + cron] or some bg queue with shelduer like DJ or sidekiq.
  def self.check_dead_sprints
    dead_sprints = Task.joins(:sprint).where{sprints.end_at < Time.now}.where{hours_worked_on_task == nil}.includes(:sprint).all.group_by(&:sprint)

    Task.public_activity_off
    
    ActiveRecord::Base.transaction do
      dead_sprints.each do |sprint, tasks|
        new_attributes = sprint.attributes
        
        new_attributes.delete('id')
        new_attributes.delete('created_at')
        new_attributes.delete('updated_at')
        new_attributes['start_at'] = Time.now.to_date
        new_attributes['end_at']   = Time.now.to_date + (sprint.end_at - sprint.start_at)
        new_attributes['title']    += '*'

        new_sprint = Sprint.new
        new_attributes.each do |k, v|
          new_sprint.send (k+'=').to_sym, v
        end
        new_sprint.save

        # better use update_all, but not critical (and it Array at last)
        tasks.each do |task|
          task.sprint = new_sprint
          task.save 
        end
      end
    end

    Task.public_activity_on

    self
  end

  private

  def next_iteration_number
    self.project.sprints.count + 1
  end

  def assign_iteration_number
    self.iteration_number = next_iteration_number
  end

end
