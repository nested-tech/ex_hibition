defmodule Fac do
  import :timer, only: [sleep: 1]

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

  @spec map(list(number()), function()) :: list(number())
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

  @spec reduce(list(number()), number(), function()) :: number()
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

  ############
  # Parallel
  ###########

  @spec double(number()) :: number()
  @doc """
  A function that returns the result of doubling the argument.
  """
  def double(number) do
    number * 2
  end

  @spec double_slowly(number()) :: number()
  @doc """
  A function that waits for a second and then returns the result of
  doubling the argument.
  """
  def double_slowly(number) do
    sleep(1_000)
    double(number)
  end

  @spec pmap(list(number()), function()) :: list(number())
  @doc """
  We have used the `map/2` function to transform a list into another, equal
  length list whose elements have are the result of calling a function on
  each element of the original list.

  This code also showcases the use of "typespecs" that can be used with a tool
  called [dialyzer](http://erlang.org/doc/man/dialyzer.html) to type check our
  elixir code. Notice the line starting with `@spec`.

  In order to get a sense for how operating on lists concurrently can be useful
  we will be using the erlang [`:timer`](http://erlang.org/doc/man/timer.html)
  module and the `double_slowly/1` function to record how long our map takes.

  Example:

      iex> doubler = &Fac.double_slowly/1
      &Fac.double_slowly/1

      iex> {time, result} = :timer.tc(
       ..>   Fac, :map, [[1,2,3], doubler]
       ..> )
      {3002632, [2, 4, 6]}

  Note:
    `:timer.tc/2` returns a tuple of `{time, result}` where time is in
    milliseconds. From the example above we see that the map operation takes
    about 3 seconds to complete.


  We can use the `pmap/2` function to do the same work as `map/2` while
  leveraging multiple concurrent processes.

  Notice how we use process identifiers to determine where to send messages
  and anonymous functions as first class citizens.

  `spawn_link` is similar to `spawn` except that it links the current process
  with the spawned/child process. This means that if the child process "dies"
  the current process will receive that signal and either manage it or exit as
  well. This leads into how supervisors work...

  Timing `pmap/2` shows that the concurrent operation is significantly faster
  than our serial `map/2` function

      iex> doubler = &Fac.double_slowly/1
      &Fac.double_slowly/1

      iex> {time, result} = :timer.tc(
       ..>   Fac, :pmap, [[3, 2, 1], doubler]
       ..> )
      {1000733, [6, 4, 2]}

  The concurrent `pmap` function take about 1 second to complete :D

  ## Do you want to know more?

  Are these functions limited to use with numbers?

  Can you think of other use cases for parallel mapping?

  When would it NOT make sense to operate concurrently?
  (hint: think about your `reduce/3` function)

  """
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
