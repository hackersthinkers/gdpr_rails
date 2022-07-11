module PolicyManager
  module ExporterHelper

    def image_tag(remote_image, opts={})
      begin
        basename = File.basename(remote_image)
        id = opts[:id] || SecureRandom.hex(10)
        composed_name = [id, basename].compact.join("-")
        path = "#{File.dirname(@base_path)}/#{composed_name}"
        save_image(remote_image, path)
        tag(:img, {src: "./#{id}-#{File.basename(URI(remote_image).path)}" }.merge(opts))
      rescue => e
        Config.error_notifier_method(e)
        content_tag(:p, "broken image")
      end
    end

    def file_tag(remote_image, opts={})
      begin
        basename = File.basename(remote_image)
        id = opts[:id] || SecureRandom.hex(10)
        composed_name = [id, basename].compact.join("-")
        path = "#{File.dirname(@base_path)}/#{composed_name}"
        save_image(remote_image, path)        
        tag.a File.basename(URI(remote_image).path), {href: "./#{id}-#{File.basename(URI(remote_image).path)}" }.merge(opts) 
      rescue => e
        Config.error_notifier_method(e)
        content_tag(:p, "broken file")
      end
    end

    private

    def save_image(remote_image, path)
      open(URI(path).path, 'wb') do |file|
        file << open(remote_image).read
      end
    end
    
  end
end


