defmodule ConstantineTest.External do
  import Constantine
  const :pos_integer, const_macro 1000 * 2
  constp :pos_integer, constp_macro 1000 * 2
end

defmodule ConstantineTest do
  use ExUnit.Case
  import Constantine
  require ConstantineTest.External

  const :pos_integer, @const_limit 1000
  const :pos_integer, @const_random_integer :rand.uniform(@const_limit)
  const :pos_integer, @const_random_integer_2x @const_random_integer * 2
  test "const attr" do
    assert @const_random_integer_2x == @const_random_integer * 2
  end

  constp :pos_integer, @constp_limit 1000
  constp :pos_integer, @constp_random_integer :rand.uniform(@constp_limit)
  constp :pos_integer, @constp_random_integer_2x @constp_random_integer * 2
  test "constp attr" do
    assert @constp_random_integer_2x == @constp_random_integer * 2
  end

  const :string, const_macro (1000 * 2) |> Integer.to_string
  test "const macto" do
    assert "2000" == const_macro()
    assert 2000 == ConstantineTest.External.const_macro()
  end

  constp :string, constp_macro (1000 * 2) |> Integer.to_string
  test "constp macto" do
    assert "2000" == constp_macro()
    refute ConstantineTest.External.__info__(:macros) |> Keyword.has_key?(:constp_macro)
  end

end
