class BugTask < Task
  enumerize :status, in: [:new, :in_work, :finished, :accepted, :rejected], predicates: true, default: :new

  state_machine :status, :initial => :new do
    event :start do
      transition :new => :in_work
    end

    event :finish do
      transition :in_work => :finished
    end

    event :accept do
      transition :done => :accepted
    end

    event :reject do
      transition :done => :rejected
    end

    event :restart do
      transition :rejected => :in_work
    end
  end

end