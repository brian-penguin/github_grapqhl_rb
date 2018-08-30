# Temp storage for files
class TempCache
  FILE_AGE_OUT_IN_DAYS = 10

  attr_reader :cache_path

  def initialize(cache_path)
    @cache_path = cache_path
  end

  def self.find_or_create(cache_path)
    new(cache_path).find_or_create
  end

  def find_or_create
    if exists?
      check_file_age!
    else
      create!
    end
  end

  private

  def exists?
    File.exist?(cache_path)
  end

  def create!
    Dir.mkdir(cache_path)
  end

  def check_file_age!
    Dir.foreach(cache_path) do |filename|
      puts "- found cached file #{filename}"
      next unless filename.split('.').last == 'json'
      file_path = "#{cache_path}/#{filename}"

      if file_older_than_age_out?(file_path)
        puts "- #{filename} is older than #{FILE_AGE_OUT_IN_DAYS} days... Deleting file"
        File.delete(file_path)
      end
    end
  end

  # TODO: move to File Helpers
  def file_older_than_age_out?(file_path)
    file_age_in_days > FILE_AGE_OUT_IN_DAYS
  end

  # TODO: move to File Helpers
  def file_age_in_days
    file_age / 86_400
  end

  # TODO: move to File Helpers
  def file_age
    (Time.now - File.ctime(file_path))
  end
end
