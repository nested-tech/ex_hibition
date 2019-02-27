# ExHibition

For learning about processes and nodes in elixir.

## Set up

... assumes Elixir/Erlang is installed and we have a terminal application to use.

We will be exploring different aspects of concurrent elixir by checking out a relevant branch and executing the elixir code via iex.

## How to follow

Checkout branches as we go or stay on master to see everything at once.

### New app

```bash
$ git checkout 0-new-application
```

### Documentation

```bash
$ git checkout 1-docs
$ mix deps.get
$ mix docs
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_hibition` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_hibition, "~> 0.1.0"}
  ]
end
```
