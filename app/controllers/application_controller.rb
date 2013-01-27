class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :set_timezone
  #, :set_locale
  include PublicActivity::StoreController

  check_authorization :unless => :skip_authorization?

  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to root_path, :alert => exception.message
  #end

  private

  def skip_authorization?
    self.kind_of?(ActiveAdmin::BaseController) || devise_controller?
  end

  #def set_locale
  #  I18n.locale = params[:locale] || :ru #|| I18n.default_locale
  #end

  def set_timezone
    Time.zone = 'Moscow'
  end


  def list_of_mentions comment
    comment.scan(/(^@(\w+))|((?<= )@(\w+))/).map{|a| a.compact!.delete_if{|m| m[0]=="@"}}.join(",").split(",")
  end


  helper_method :list_of_mentions
end
