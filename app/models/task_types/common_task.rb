class CommonTask < Task
  enumerize :type, :in => [self.to_s] #HOOK for enumerize
  enumerize :status, in: [:new, :in_work, :finished, :accepted, :rejected], predicates: true, default: :new

  state_machine :status, :initial => :new do
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

end