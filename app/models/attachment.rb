class Attachment < ActiveRecord::Base
  attr_accessible :attachable_id, :attachable_type, :filename, :filesize

  validates_presence_of :filename

  belongs_to :attachable, :polymorphic => true
  mount_uploader :filename, AttachmentUploader

  before_create :set_size

  def url(size = nil)
    size ? filename.url(size) : filename.url
  end

  def set_size
    self.filesize = self.filename.size
    #save
  end
end
