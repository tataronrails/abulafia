class ProjectsFactory
  attr_accessor :user, :project, :is_project_saved

  def initialize(*args)
    @options = args.extract_options!
    self.user  = @options.delete(:user ).presence || nil
    self.project = @options.delete(:project).presence || nil
    self.is_project_saved = false
    self
  end

  def project=(value)
    # value.validate
    @project = value
  end

  def create_project!
    if self.project.valid?
      ActiveRecord::Base.transaction do
        self.project.save!
        self.project.project_memberships.create!(user: self.user, role: 'admin')
        self.is_project_saved = true
      end
    end
  end

  def project_saved?
    self.is_project_saved
  end
end