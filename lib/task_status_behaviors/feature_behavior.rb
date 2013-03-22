class FeatureBehavior
  def initialize(task)
    @task = task
    @state = task.status
  end

  state_machine :state, :initial => :estimate do
    after_transition any => any, :do => :save_state

    event :starting do
      transition :estimate => :start
    end

    event :finishing do
      transition :start => :finish
    end

    event :push do
      transition :finish => :pushed
    end

    event :accept do
      transition :pushed => :accepted
    end

    event :reject do
      transition :pushed => :rejected
    end

    event :restart do
      transition :rejected => :start
    end

    state :estimate, :value => 0
    state :start,    :value => 1
    state :finish,   :value => 2
    state :pushed,   :value => 3
    state :accepted, :value => 6
    state :rejected, :value => 7
  end

  private

  def save_state
    @task.update_attributes! :status => @state
  end
end