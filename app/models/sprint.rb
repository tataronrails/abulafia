class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :tasks
  attr_accessible :desc, :end_at, :start_at, :title

  scope :alive, where{end_at > Time.now}

  def short_desc
    "#{title} (#{I18n.l start_at, format: :short} - #{I18n.l end_at, format: :short})"
  end
end
