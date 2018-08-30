# Temp storage for files
class TempCache
  FILE_AGE_OUT_IN_DAYS = 10

  attr_reader :cache_path

  def initialize(cache_path)
    @cache_path = cache_path
  end

  def self.find_or_create(cache_path)
    cache = new(cache_path)
    if cache.exists?
      cache.check_file_age!
    else
      cache.create!
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

  def file_older_than_age_out?(file_path)
    (Time.now - File.ctime(file_path))/(24*3600) > FILE_AGE_OUT_IN_DAYS
  end
end
