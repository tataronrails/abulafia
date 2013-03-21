class ChoreBehavior
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

    event :loop do
      transition :finish => :estimate
    end

    state :estimate, :value => 0
    state :start,    :value => 1
    state :finish,   :value => 2
  end

  private

  def save_state
    @task.update_attributes! :status => @state
  end
end