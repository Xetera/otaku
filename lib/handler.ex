defmodule Otaku.Handler do
  @moduledoc "Handler for http requests"

  @image_key "image"
  @auth_key "authorization"

  use Plug.Router
  require Logger

  plug Plug.Logger

  plug Plug.Parsers, parsers: [:json, :multipart], json_decoder: Poison
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  def start_link do
    { :ok, _ } = Plug.Adapters.Cowboy.http(__MODULE__, [])
  end

  defp words(string) do
    string
    |> String.split(" ")
  end

  post "/upload" do
    headers = Enum.into(conn.req_headers, %{ })

    with { :ok, image } <- get_image(conn.body_params),
         { :ok, { auth_type, jwt } } <- get_auth_header(headers),
         { :ok, _ } <- verify_auth(auth_type),
         { :ok, token } <- verify_token(jwt),
         { :ok, res } <- Otaku.Uploader.upload_image(image, token["user_id"])
      do
      send_resp(conn, 200, Poison.encode!(%{ "url" => res }))
    else
      err ->
        IO.inspect(err)
        { code, reason } = handle_error err
        send_resp(conn, code, Poison.encode!(reason))
    end
  end

  defp get_image(body) do
    if Map.has_key?(body, @image_key) do
      image = body[@image_key]
      IO.inspect image
      { :ok, image }
    else
      { :input_error, "Expected 'image' inside form data but found none." }
    end
  end

  defp get_auth_header(headers) do
    if Map.has_key?(headers, @auth_key) do
      auth = headers[@auth_key]
      IO.inspect auth
      [auth_type, jwt] = words auth
      { :ok, { auth_type, jwt } }
    else
      { :jwt_error, "Missing Authorization header" }
    end
  end

  defp verify_token(auth) do
    case Jwt.verify(auth) do
      { :ok, out } -> { :ok, out }
      { :error, reason } -> { :jwt_error, reason }
    end
  end

  defp verify_auth(auth) do
    case auth do
      "Bearer" -> { :ok, nil }
      _ -> { :jwt_error, "Invalid Authorization type" }
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
end
