defmodule ConstantineTest do
  use ExUnit.Case
  import Constantine, only: [const: 2]

  const :pos_integer, @limit 1000
  const :pos_integer, @random_integer :rand.uniform(@limit)
  const :pos_integer, @random_integer_2x @random_integer * 2

  test "test" do
    assert @random_integer_2x == @random_integer * 2
  end

end
