defmodule Arcanjo.Consurmer.Helpers.DiceHelper do
  alias Nostrum.Api

  @api_url "https://www.randomnumberapi.com/api/v1.0/random?min=1&max=7&count=1"

  def handle(msg) do
    result = get_dice_roll(validate_dice_command(msg.content))
    Api.Message.create(msg.channel_id, result)
  end

  defp validate_dice_command(content) do
    case String.split(content, " ") do
      ["!dado"] -> :ok
      _ -> :error
    end
  end

  defp get_dice_roll(:ok) do
    case HTTPoison.get(@api_url, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, [dice_roll]} ->
            format_dice_response(dice_roll)

          _ ->
            "Erro ao processar os dados da API do dado."
        end

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        "Erro da API Random Number API (#{status}): #{body}"

      {:error, %HTTPoison.Error{reason: reason}} ->
        "Erro ao conectar à API Random Number API: #{reason}"
    end
  end

  defp get_dice_roll(_) do
    "Comando inválido. Use: **!dado**"
  end

  defp format_dice_response(6) do
    """
    🎲 O dado rolou **6**! Parece que você deve ir pra aula...
    Mas vamos jogar novamente, esse dado tá estranho! 😅
    """
  end

  defp format_dice_response(dice_roll) do
    """
    🎲 O dado rolou **#{dice_roll}**! Você pode ficar em casa. Aproveite o descanso! 😎
    """
  end
end
