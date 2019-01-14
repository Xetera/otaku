defmodule Otaku.Server do
  @moduledoc "Upload server"
  use Application

  def start(type, args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Otaku.Handler, [])
    ]

    opts = [strategy: :one_for_one, name: HexVersion.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
