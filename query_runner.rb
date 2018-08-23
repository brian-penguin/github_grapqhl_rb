# Execute some Queries!
# TODO: this should exist in the github namespace
class QueryRunner
  def self.run
    new.run
  end

  def run
    result = client.query(GithubQueries::ME)
    puts result.data.viewer.login
  end

  def client
    GithubApi::Client
  end
end

module GithubQueries
  ME = GithubApi::Client.parse <<-'GRAPHQL'
    query {
      viewer {
        login
      }
    }
  GRAPHQL
end
