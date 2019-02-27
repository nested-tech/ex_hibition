defmodule Fac do
  import :timer, only: [sleep: 1]

  ############
  # Examples
  ############
  def map(list, function) do
    map(list, [], function)
  end

  defp map([head | tail], results, function) do
    result = function.(head)

    map(tail, results ++ [result], function)
  end

  defp map([], results, _function), do: results

  def double(number) do
    number * 2
  end

  def double_slowly(number) do
    sleep(1_000)
    double(number)
  end

  @doc """

  ADD DOC TESTS HERE PLZ

  """
  @spec pmap(list(number()), function()) :: list(number())
  def pmap(numbers, doubler) do
    me = self()

    concurrent_doubler = fn number ->
      spawn_link(fn ->
        send(me, {self(), doubler.(number)})
      end)
    end

    receiver = fn pid ->
      receive do
        {^pid, result} -> result
      end
    end

    numbers
    |> Enum.map(concurrent_doubler)
    |> Enum.map(receiver)
  end
end
