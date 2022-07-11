# -*- encoding : utf-8 -*-
require "carrierwave"

module PolicyManager::Concerns::CarrierwaveBehaviour
  extend ActiveSupport::Concern
  
  class Uploader < CarrierWave::Uploader::Base
    storage PolicyManager::Config.exporter.try(:attachment_storage) || :file
    
    def store_dir
      PolicyManager::Config.exporter.try(:attachment_path) || "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  included do
    mount_uploader :attachment, Uploader    
  end

  def file_remote_url=(url_value)
    self.attachment = File.open(url_value) unless url_value.blank?
    self.save
    self.complete!
  end

  def fog_authenticated_url_expiration
    PolicyManager::Config.exporter.expiration_link
  end

  def download_link
    url = self.attachment.url
    PolicyManager::Config.exporter.customize_link(url)
  end
end
