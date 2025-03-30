defmodule Arcanjo do
  use Application

  def start(_type, _args) do
    children = [
      Arcanjo.Consumer
    ]

    opts = [strategy: :one_for_one, name: Arcanjo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
