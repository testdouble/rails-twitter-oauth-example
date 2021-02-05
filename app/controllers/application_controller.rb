class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    @current_user = User.first || User.create!(
      name: `whoami`.capitalize,
      email: "#{`whoami`}@example.com",
      password: "lol"
    )
  end
end
