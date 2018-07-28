defmodule Constantine do

  defmacro const(type, {:@, meta, [{attr_name, attr_meta, [expression]}]}) do
    {:@, meta, [{attr_name, attr_meta, [generate_typecheck(type, expression, attr_name)]}]}
  end
  defmacro const(type, {name, _, [expression]}) do
    {result, _} = generate_typecheck(type, expression, name) |> Code.eval_quoted
    quote do
      defmacro unquote(name)() do
        unquote(result)
      end
    end
  end

  defmacro constp(type, {:@, meta, [{attr_name, attr_meta, [expression]}]}) do
    {:@, meta, [{attr_name, attr_meta, [generate_typecheck(type, expression, attr_name)]}]}
  end
  defmacro constp(type, {name, _, [expression]}) do
    {result, _} = generate_typecheck(type, expression, name) |> Code.eval_quoted
    quote do
      defmacrop unquote(name)() do
        unquote(result)
      end
    end
  end

  defp generate_typecheck(type, expression, attr_name) do
    typecheck_code =
      case type do
        # base types
        :boolean -> quote do is_boolean(result) end
        :atom -> quote do is_atom(result) and (result != nil) end
        :binary -> quote do is_binary(result) and (result != "") end
        :string -> quote do String.valid?(result) and (result != "") end
        # numbers
        :number -> quote do is_number(result) end
        :pos_number -> quote do is_number(result) and (result > 0) end
        :non_neg_number -> quote do is_number(result) and (result >= 0) end
        # integers
        :integer -> quote do is_integer(result) end
        :pos_integer -> quote do is_integer(result) and (result > 0) end
        :non_neg_integer -> quote do is_integer(result) and (result >= 0) end
        # floats
        :float -> quote do is_float(result) end
        :pos_float -> quote do is_float(result) and (result > 0) end
        :non_neg_float -> quote do is_float(result) and (result >= 0) end
        # composite types
        :map -> quote do is_map(result) end
        :list -> quote do is_list(result) end
        :tuple -> quote do is_tuple(result) end
        :keyword -> quote do Keyword.keyword?(result) end
        :regex -> quote do Regex.regex?(result) end
        # enum
        {:enum, values = [_|_]} -> quote do Enum.member?(unquote(values), result) end
        # default
        some -> raise("Unsupported const type #{inspect some} for const #{inspect attr_name}")
      end
    quote do
      (
        result = (unquote(expression))
        case (unquote(typecheck_code)) do
          true -> result
          false -> raise("Const type check failed. Required type #{inspect unquote(type)}. Value #{inspect result}. Const name #{inspect unquote(attr_name)}.")
        end
      )
    end
  end

end
