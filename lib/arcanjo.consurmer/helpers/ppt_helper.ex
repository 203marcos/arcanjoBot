defmodule Arcanjo.Consurmer.Helpers.PPTHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = validate_ppt_command(msg.content) |> return_ppt_result()
    Api.Message.create(msg.channel_id, result)
  end

  defp validate_ppt_command(content) do
    case String.split(content, " ") do
      ["!ppt", player_choice] when player_choice in ["pedra", "papel", "tesoura"] ->
        {:ok, player_choice}

      _ ->
        :error
    end
  end

  defp return_ppt_result({:ok, player_choice}) do
    bot_choice = Enum.random(["pedra", "papel", "tesoura"])

    cond do
      bot_choice == player_choice -> "Houve um empate! :face_with_spiral_eyes:"
      bot_choice == "pedra" and player_choice == "tesoura" -> "O bot venceu! :star_struck:"
      bot_choice == "tesoura" and player_choice == "papel" -> "O bot venceu! :star_struck:"
      bot_choice == "papel" and player_choice == "pedra" -> "O bot venceu! :star_struck:"
      true -> "Você venceu! :sob:"
    end
  end

  defp return_ppt_result(_) do
    "Comando inválido. Use: **!ppt pedra|papel|tesoura**"
  end
end
