defmodule MassagePassingSystemTest do
  use ExUnit.Case
  doctest MassagePassingSystem

  test "greets the world" do
    assert MassagePassingSystem.hello() == :world
  end
end
