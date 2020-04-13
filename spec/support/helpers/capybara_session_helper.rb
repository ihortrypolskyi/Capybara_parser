module CapybaraSessionHelper
  def use_current_session
    Capybara.current_session.instance_variable_set(:@touched, false)
  end

  def reset_session
    Capybara.reset_sessions!
  end
end
