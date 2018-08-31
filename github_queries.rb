# Wrapper for all the possible queries we could run
module GithubQueries
  # TODO: figure out why I can't nest constants
  # Defaults
  DEFAULT_PER_PAGE = 50

  # Fragments
  UserFragment = GithubApi::Client.parse <<-'GRAPHQL'
    fragment on User {
      name
      login
      avatarUrl
    }
  GRAPHQL

  # Queries
  ME = GithubApi::Client.parse <<-'GRAPHQL'
    query {
      viewer {
        login
        name
        id
      }
    }
  GRAPHQL

  # Gets user's name, login, and avatar link and their organizations logins and names
  USER_INFO = GithubApi::Client.parse <<-'GRAPHQL'
    query($login: String!) {
      user(login: $login) {
        name
        login
        avatarUrl
        organizations(first: 50) {
          totalCount
          pageInfo{
            hasNextPage
            endCursor
          }
          nodes {
            name
            login
          }
        }
      }
    }
  GRAPHQL

  ORGANIZATION_INFO = GithubApi::Client.parse <<-'GRAPHQL'
    query($organization_login: String!) {
      organization(login: $organization_login) {
        teams(first: 100) {
          pageInfo {
            hasNextPage
            endCursor
          }
          nodes {
            name
            members(first: 100) {
              totalCount
              pageInfo {
                hasNextPage
                endCursor
              }
              nodes {
                login
              }
            }
          }
        }
      }
    }
  GRAPHQL
end
