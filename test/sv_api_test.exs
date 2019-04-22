defmodule SvApiTest do
  use ExUnit.Case
  doctest SvApi

  test "greets the world" do
    assert SvApi.hello() == :world
  end
end
