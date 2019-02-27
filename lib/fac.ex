defmodule Fac do
  ############
  # Examples
  ############

  @moduledoc """
  The fruits of your labour
  """

  # Functions

  @doc """
  Returns the sum of two arguments

      iex> Fac.sum(1, 2)
      3

  """
  def sum(x, y) do
    x + y
  end

  @doc """
  Returns half the result of the sum

      iex> Fac.sum_and_a_half(1, 2)
      1.5

  """
  def sum_and_a_half(x, y) do
    z = x + y
    z / 2
  end

  @doc """
  Returns the sum of two arguments

      iex> Fac.multiply(1, 2)
      2

  """
  def multiply(x, y) do
    x * y
  end

  # Anonymous functions

  @doc """
  Applies a function to the given arguments

      iex> sum = &Fac.sum/2
      &Fac.sum/2

      iex> Fac.apply(sum, [1, 2])
      3

      iex> anon_add_and_halve = fn x, y ->
      ...>    z = x + y
      ...>    z / 2
      ...> end
      #Function<12.128620087/2 in :erl_eval.expr/5>

      iex> Fac.apply(anon_add_and_halve, [1, 2])
      1.5

  """
  def apply(function, [first, second]) do
    function.(first, second)
  end

  @doc """
      iex> add_two = fn x -> x + 2 end
      #Function<6.128620087/1 in :erl_eval.expr/5>

      iex> double = fn x -> x * 2 end
      #Function<6.128620087/1 in :erl_eval.expr/5>

      iex> apply([add_two, double], 2)
      8

  """
  def apply([function_1, function_2], value) do
    value
    |> function_1.()
    |> function_2.()
  end

  # Pattern matching

  @doc """
  Determines if a list is empty

      iex> Fac.is_empty_list([])
      true

      iex> Fac.is_empty_list([42])
      false

  """
  def is_empty_list([]), do: true
  def is_empty_list(_list), do: false

  # Pattern matching with strings

  @doc """
  Responds with "Goodbye" do greeted with "Hello"

      iex> Fac.hello_goodbye("Hello Faccer")
      {:ok, "Goodbye Faccer"}

      iex> Fac.hello_goodbye("Monkey")
      {:error, "no hello"}

  """
  def hello_goodbye("Hello " <> text), do: {:ok, "Goodbye #{text}"}
  def hello_goodbye(_text), do: {:error, "no hello"}

  # Recursion

  @doc """
  Uses recursion to sum two numbers

      iex> Fac.loop_add(1, 2)
      3

  """
  def loop_add(x, 0), do: x
  def loop_add(x, y), do: loop_add(x + 1, y - 1)

  # Lists

  @doc """
  Applies a function to each element of a list

      iex> Fac.for_each([0, 1, 2, 3], fn val -> IO.puts(val) end)
      0
      1
      2
      3
      :ok

  """
  def for_each([head | tail], function) do
    function.(head)
    for_each(tail, function)
  end

  def for_each([], _function), do: :ok

  @doc """
  Transforms each element of a list using the given function and returns
  a list of the transformed results

      iex> Fac.map([0, 1, 2, 3], fn val -> val * 2 end)
      [0, 2, 4, 6]
  """
  def map(list, function) do
    map(list, [], function)
  end

  defp map([head | tail], results, function) do
    result = function.(head)

    map(tail, results ++ [result], function)
  end

  defp map([], results, _function), do: results

  @doc """
  Combines an accumulator with each element of a list using the given function

      iex> Fac.reduce([0, 1, 2, 3], 0, fn val, acc -> val + acc end)
      6
  """
  def reduce([], accumulator, _function), do: accumulator

  def reduce([head | tail], accumulator, function) do
    new_accumulator = function.(head, accumulator)

    reduce(tail, new_accumulator, function)
  end

  ############
  # Processes
  ############

  @doc """
  We can call any function directly:

      iex> Fac.hello_goodbye("Hello Person")
      {:ok, "Goodbye Person"}

  or we can spawn a separate process to run the function:

      iex> spawn Fac, :hello_goodbye, ["Hello Person"]
      #PID<0.162.0>

  But where did the "Goodbye" go?

  We will use a `greeter` function to spawn a process that waits for a message before
  sending a greeting back:

      iex> pid = spawn Fac, :greeter, []
      #PID<0.139.0>

      iex> send(pid, {self(), "Hello Faccer"})
      {#PID<0.137.0>, {:ok, "Goodbye Faccer"}}

  Note:
    `self()` returns the process identifier (pid) for current process.
     In this case, the pid for the iex session (`#PID<0.137.0>`)


  In order to receive the greeting we need to have a corresponding `receive`
  block:

      iex> receive do
       ..> {:ok, message} ->
       ..>   IO.puts(message)
       ..> end
      {:ok, "Goodbye Faccer"}
      :ok

  ## Do you want to know more?

  What happens if we send the greeter another message?

  Let's look up how to add a timeout to our mailbox
  (hint: we want to use the `after` keyword).

  Use `flush`

  We should also set up the greeter to respond to more than one message
  (hint: we can use recursion...)
  """
  def greeter do
    receive do
      {sender, greeting} ->
        send(sender, hello_goodbye(greeting))
    end
  end
end
