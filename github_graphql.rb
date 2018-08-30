require_relative 'github_api.rb'
require_relative 'query_runner.rb'
require_relative 'temp_cache.rb'

# The entry path to the app
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
    TempCache.find_or_create(CACHE_DIR_PATH)
  end
end
