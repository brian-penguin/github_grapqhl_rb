require_relative 'github_api.rb'
require_relative 'query_runner.rb'
require_relative 'temp_cache.rb'

# The entry path to the app
class GithubGraphqlApp
  CACHE_DIR_PATH = 'cache'.freeze

  def start
    puts 'Starting'
    client = setup_client
    run_queries(client)
    puts 'Done!'
  end

  def setup_client
    reset_cache
    # Initializes the client with the cached schemas
    GithubApi::Client
  end

  def run_queries(client)
    QueryRunner.run
  end

  def reset_cache
    TempCache.find_or_create(CACHE_DIR_PATH)
  end
end
