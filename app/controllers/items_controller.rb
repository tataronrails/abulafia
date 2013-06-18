# encoding: UTF-8
# абстрактный контроллер
class ItemsController < ApplicationController
  inherit_resources
  has_scope :page, :default => 1
  has_scope :per, :default => 45
end