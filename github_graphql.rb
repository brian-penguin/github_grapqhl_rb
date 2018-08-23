require_relative 'github_api.rb'
require_relative 'query_runner.rb'

# The root
class GithubGraphql
  CACHE_DIR_PATH = 'cache'.freeze

  def self.start
    puts 'Starting'
    setup
    run
    puts 'Done!'
  end

  def self.setup
    reset_cache
    GithubApi::Client
  end

  def self.run
    QueryRunner.run
  end

  def self.reset_cache
    # if cache dir doesn't exist, create it
    # if cache does exist, check each file and delete anything older than a day
    cache = TempCache.new(CACHE_DIR_PATH)
    if cache.exists?
      cache.check_file_age
    else
      cache.create!
    end
  end
end

# Temp storage for files
class TempCache
  attr_reader :cache_path

  def initialize(cache_path)
    @cache_path = cache_path
  end

  def exists?
    File.exist?(cache_path)
  end

  def create!
    Dir.mkdir(cache_path)
  end

  def check_file_age
    Dir.foreach(cache_path) do |filename|
      puts "- found cached file #{filename}"
      next unless filename.split('.').last == 'json'
      file_path = "#{cache_path}/#{filename}"

      if file_older_than_3_days(file_path)
        puts "- #{filename} is older than one day... Deleting file"
        File.delete(file_path)
      end
    end
  end

  private

  def file_older_than_3_days(file_path)
    (Time.now - File.ctime(file_path))/(24*3600) > 3
  end
end
