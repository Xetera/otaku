defmodule OtakuTest do
  use ExUnit.Case
  doctest Otaku

  test "greets the world" do
    assert Otaku.hello() == :world
  end
end
