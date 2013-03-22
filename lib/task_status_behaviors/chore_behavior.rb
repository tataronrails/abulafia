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
      transition :start => :accepted
    end

    state :estimate, :value => 0
    state :start,    :value => 1
    state :accepted, :value => 6
  end

  private

  def save_state
    @task.update_attributes! :status => @state
  end
end