class FeatureTask < Task
  enumerize :type, :in => [self.to_s] #HOOK for enumerize
  enumerize :status, in: [:new, :in_work, :accepted], predicates: true, default: :new

  state_machine :status, :initial => :new do
    event :start do
      transition :new => :in_work
    end

    event :finish do
      transition :in_work => :accepted
    end
  end

end