class EasyBehavior
  def initialize(task)
    @task = task
    @state = task.status
  end

  state_machine :state, :initial => :estimate do
    after_transition any => any, :do => :save_state

    event :finishing do
      transition :estimate => :accepted
    end

    state :estimate, :value => 0
    state :accepted, :value => 6
  end

  private

  def save_state
    @task.update_attributes! :status => @state
  end
end