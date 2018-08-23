# The root
class GithubGraphql
  def self.start
    puts 'Starting'
    setup
  end

  def self.setup
    # if the cache file exists and is 1 day old or newer skip client initializing
    # else
    # recreate the cache!
  end
end
