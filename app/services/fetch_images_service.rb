class FetchImagesService
  require 'logger'
  require 'open-uri'

  attr_reader :logger
  
  OUTPUT_FOLDER = "#{Rails.root}/images_store/"

  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  def process_file(path_to_file)
    count_successes = 0
    if !path_to_file.nil?
      if File.exist?(path_to_file)
        urls_to_images = File.readlines(path_to_file, chomp: true)
        urls_to_images.each do |url_to_image|
          if download_image(url_to_image)
            count_successes+=1
          end
        end
      else
        @logger.error("File not found: #{path_to_file}")
        return false
      end
    else
      @logger.error("Please provide a file path.")
      return false
    end
    @logger.info("#{count_successes} Files downloaded to: #{OUTPUT_FOLDER}")
    return true
  end

  def download_image(url_to_image)
    begin
      download = open(url_to_image)
      if download.base_uri.to_s == url_to_image
        IO.copy_stream(download, "#{OUTPUT_FOLDER}/#{download.base_uri.to_s.split('/')[-1]}")
        @logger.info("File downloaded: #{url_to_image}")
        return true
      else
        @logger.error("File not available: #{url_to_image}, Redirected to: #{download.base_uri.to_s}")
        return false
      end
    rescue SocketError => e
      @logger.error("File not available: #{url_to_image}")
      return false
    end
  end
end
