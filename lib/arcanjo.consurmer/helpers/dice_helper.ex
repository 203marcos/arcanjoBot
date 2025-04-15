defmodule Arcanjo.Consurmer.Helpers.DiceHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = roll_dice()
    Api.Message.create(msg.channel_id, result)
  end

  defp roll_dice() do
    "🎲 Você rolou o número: #{Enum.random(1..6)}"
  end
end
