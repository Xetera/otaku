defmodule Otaku.Uploader do
  @moduledoc "Uploader for bunnycdn"

  @bunny_cdn_url "https://storage.bunnycdn.com"

  require Logger

  def access_key, do: System.get_env("OTAKU_ACCESS_KEY")
  def storage, do: System.get_env("OTAKU_STORAGE")
  def hosted_url, do: System.get_env("OTAKU_CDN_URL") || "https://i.love.hifumi.io"

  def upload_headers, do: [{ "AccessKey", access_key }]

  def base_url, do: "#{@bunny_cdn_url}/#{storage}"

  def upload_image(%Plug.Upload{ :path => path, :filename => filename }, user) do
    ext = "#{user}/#{filename}"
    out = "#{base_url}/#{ext}"
    Logger.debug "Uploading to image to #{out}"

    case HTTPoison.put(out, { :file, path }, upload_headers) do
      { :ok, res } -> { :ok, "#{hosted_url}/#{ext}" }
      { _, reason } -> { :upload_error, reason }
    end
  end
end
