require 'graphql/client'
require 'graphql/client/http'

# A quick GraphQL client wrapper for github
module GithubApi
  CACHE_PATH = 'cache/github_schemas.json'.freeze

  HTTP = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(_context)
      { 'Authorization' => "bearer #{ENV['GITHUB_TOKEN']}" }
    end
  end

  # TODO: also check the age of the file

  unless File.exist?(GithubApi::CACHE_PATH)
    GraphQL::Client.dump_schema(GithubApi::HTTP, GithubApi::CACHE_PATH)
  end

  Schema = GraphQL::Client.load_schema(GithubApi::CACHE_PATH)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
