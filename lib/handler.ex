defmodule Otaku.Handler do
  @moduledoc "Handler for http requests"
  use Plug.Router
  #  use Ok.Pipe
  require Logger

  plug Plug.Logger
  #  plug Plug.MIME

  plug Plug.Parsers, parsers: [:json, :multipart], json_decoder: Poison
  #  config :plug, :mimes, %{
  #    "image/png" => ["png"]
  #  }
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    # NOTE: This starts Cowboy listening on the default port of 4000
    { :ok, _ } = Plug.Adapters.Cowboy.http(__MODULE__, [])
  end

  post "/upload" do
    memes = conn.body_params["image"]
    %Plug.Upload{ :path => path } = memes
    IO.inspect memes
    with { :ok, bin } <- File.read! path
      # { :ok, token } <- extract_jwt(conn.body_params),
      # { :ok, image } <- extract_image(conn.req_headers),
      # { :ok, verify } <- verify_token(token)

      do
      IO.inspect bin
      HTTPoison.put()
      send_resp(conn, 200, Poison.encode!(memes))
    else
      err ->
        IO.inspect err
        { code, reason } = err
                           |> handle_error
                           |> Poison.encode!
        send_resp(conn, code, reason)
    end
  end

  defp verify_token(token) do
    case Jwt.verify(token) do
      { :ok, out } -> { :ok, out }
      { :error, reason } -> { :jwt_error, reason }
    end
  end

  defp handle_error(input) do
    case input do
      { :error, reason } -> { 500, %{ "error" => reason } }
      { :jwt_error, reason } -> { 401, %{ "jwt_error" => reason } }
      { :input_error, reason } -> { 400, %{ "malformed_input" => reason } }
      { _, reason } -> { 500, %{ "error" => reason } }
    end
  end

  defp get_input(body, key, location \\ "request") do
    if Map.has_key?(body, key) do
      val = Map.get(body, key)
      { :ok, val }
    else
      { :input_error, missing_input(key, location) }
    end
  end

  defp missing_input(type, location), do: "Missing '#{type}' value in #{location}"

  defp extract_jwt(headers) do
    IO.inspect headers
    auth = get_input(headers, "Authorization", "header")
    1
  end

  defp extract_image(body) do
    get_input(body, "image")
  end
end
