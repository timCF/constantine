defmodule ConstantineTest do
  use ExUnit.Case
  doctest Constantine

  test "greets the world" do
    assert Constantine.hello() == :world
  end
end
