require 'pry'
require_relative 'github_queries'
# Execute some Queries!
# TODO: this should exist in the github namespace
class QueryRunner
  def self.run
    new.run
  end

  def run
    me = GithubResult.new(client.query(GithubQueries::ME)).data!
    my_login = me.viewer.login
    puts my_login
    current_user_id = me.viewer.id

    result = GithubResult.new(
      client.query(
        GithubQueries::USER_INFO,
        variables: {
          login: 'nasdfasdfj;lkjsdflkjas'
        },
        context: {
          user_id: current_user_id
        }
      )
    )

    binding.pry

    my_orgs = data.user.organizations.nodes.map(&:login)
    puts my_orgs.inspect
  end

  def client
    @client ||= GithubApi::Client
  end
end

class GithubResult
  attr_reader :result

  def initialize(result)
    @result = result
  end

  def success?
    return true unless errors
    errors.empty?
  end

  def data
    return nil unless success?
    result.data
  end

  def data!
    raise StandardError.new(error_message) unless success?

    result.data
  end

  private

  def errors
    # sometimes result.errors doesn't include not-found errors
    result.original_hash.dig('errors')
  end

  def error_message
    errors.map do |err|
      "GithubApi Error: #{err.type}, #{err.messages.join('- ')} #{err.details.join('- ')}"
    end.join("\n")
  end

end
