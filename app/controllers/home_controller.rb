class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  skip_authorization_check

  def index
  end
end
