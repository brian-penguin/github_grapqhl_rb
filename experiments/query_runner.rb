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
          login: my_login
        },
        context: {
          user_id: current_user_id
        }
      )
    )

    my_orgs = result.data_hash.dig('user', 'organizations', 'nodes')
    # Use the logins to find the teams -> use the teams to check membership
    my_org_logins = my_orgs.map { |org_values| org_values['login'] }

    my_teams = []
    my_teams_members = {}

    my_org_logins.each do |org_login|
      # Make an org request per org
      result = GithubResult.new(
        client.query(
          GithubQueries::ORGANIZATION_INFO,
          variables: {
            organization_login: org_login
          },
          context: {
            user_id: current_user_id
          }
        )
      )

      data = result.data_hash

      teams = data.dig('organization', 'teams', 'nodes')

      teams.each do |team|
        team_name = team['name']
        members = team.dig('members', 'nodes')
        member_logins = members.map { |node| node['login'] }

        if member_logins.include?(my_login)
          my_teams << team_name
          my_teams_members[team_name] = member_logins
        end
      end
    end

    puts my_teams
    puts my_teams_members
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

  def data_hash
    data.to_h
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
