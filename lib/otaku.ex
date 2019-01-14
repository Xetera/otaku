defmodule Otaku.Server do
  @moduledoc "Upload server"
  use Application

  require Logger

  def start(type, args) do
    import Supervisor.Spec, warn: false

    if Otaku.Uploader.access_key() == nil do
      Logger.error "OTAKU_ACCES_KEY environment variable required but not found"
      exit(:shutdown)
    end

    if Otaku.Uploader.storage() == nil do
      Logger.error "OTAKU_STORAGE environment variable required but not found"
      exit(:shutdown)
    end

    children = [
      worker(Otaku.Handler, [])
    ]

    opts = [strategy: :one_for_one, name: HexVersion.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
