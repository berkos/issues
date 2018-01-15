defmodule Issues.GithubIssues do
  require Logger
  @user_agent [{"User-agent", "Antonis Elixir Client"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    Logger.info "#{@github_url}/repos/#{user}/#{project}/issues"
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.debug fn -> inspect(body) end
    { :ok, Poison.Parser.parse!(body) }
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error status #{status} returned"
    { :error, Poison.Parser.parse!(body) }
  end
end
