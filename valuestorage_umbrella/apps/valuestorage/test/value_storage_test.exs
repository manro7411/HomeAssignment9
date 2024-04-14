defmodule ValueStorageTest do
  use ExUnit.Case
  doctest ValueStorage

  test "greets the world" do
    assert ValueStorage.hello() == :world
  end
end
