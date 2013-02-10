class FeatureTask < Task
  enumerize :status, in: [:new, :in_work, :finished, :accepted, :rejected], predicates: true, default: :new

  state_machine :status, :initial => :new do
    after_transition :new => :in_work, :do => :to_current

    event :start do
      transition :new => :in_work, :if => lambda { |task| task.estimate.present? }
    end

    event :finish do
      transition :in_work => :finished
    end

    event :accept do
      transition :finished => :accepted
    end

    event :reject do
      transition :finished => :rejected
    end

    event :restart do
      transition :rejected => :in_work
    end
  end

  private

  def to_current
    self.update_attributes!(:place => :current)
  end
end