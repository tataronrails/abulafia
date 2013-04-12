class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "system/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb, :if => :image? do
    process :resize_to_limit => [150, 150]
  end

  private

  def image?(file)
    file.content_type[/\w*/] == 'image'
  end
end