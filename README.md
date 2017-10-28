# Constantine

Type-safe macro to define constants as module attributes in Elixir language. All expressions and checks are evaluated in compile time.

# Usage

How many times you suffered from runtime errors when your application depends on external system env, configs, files? Forgot to configure env variables before production build and your application crashed in a random unpredictable runtime moment? Compiler is your friend, so let him to check your env. No more runtime errors because missing or wrong configuration! Define module attributes like a ninja using `const/2` macro. First argument is type and second is module attribute expression what produces value of given type. Below you can find list of supported types. **Empty string and nil are not allowed as const**

```
:atom
:binary
:string
:number
:pos_number
:non_neg_number
:integer
:pos_integer
:non_neg_integer
:float
:pos_float
:non_neg_float
:map
:list
:tuple
:keyword
{:enum, values = [_|_]}
```

# Example

```elixir
defmodule API do

  import Constantine, only: [const: 2]
  const :string,      @host     System.get_env("API_HOST")
  const :pos_integer, @port     System.get_env("API_PORT") |> String.to_integer
  const :string,      @trx_url  "http://#{@host}:#{@port}/trx"
  const :binary,      @privkey  "#{:code.priv_dir(:api)}/privkey.pem" |> File.read!

  def trx(params = %{}) do
    request = Poison.encode!(params)
    %HTTPoison.Response{body: response} = HTTPoison.post!(@trx_url, request, ["X-Signature": sign(request)])
    Poison.decode!(response)
  end

  defp sign(data) do
    :crypto.sign(:rsa, :sha256, data, @privkey)
  end

end
```
