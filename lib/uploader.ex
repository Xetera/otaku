defmodule Uploader do
  @moduledoc false

  def upload_headers do
    ["AccessKey": System.get_env("AccessKey")]
  end

end
