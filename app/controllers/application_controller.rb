class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :set_timezone, :set_locale

  check_authorization :unless => :devise_controller?

  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to root_path, :alert => exception.message
  #end

  private

  def set_locale
    I18n.locale = params[:locale] || :ru #|| I18n.default_locale
  end

  def set_timezone
    Time.zone = 'Moscow'
  end
end