defmodule Arcanjo.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_status}) do
    cond do
      String.starts_with?(msg.content, "!ping") ->
        Api.Message.create(msg.channel_id, "pong!")

      String.starts_with?(msg.content, "!oie") ->
        embed = %{
          title: "Olá",
          description: "Tudo bem com você? Segue a lista de comandos disponível",
          color: 0x0074E7,
          fields: [
            %{
              name: "!ppt",
              value: "Use este comando para jogar pedra, papel ou tesoura",
              inline: true
            }
          ],
          author: %{
            name: "ArcanjoBot"
          }
        }

        Api.Message.create(msg.channel_id, %{embed: embed})

      String.starts_with?(msg.content, "!ppt") ->
        result = return_ppt_result(validate_ppt_command(msg.content))
        Api.Message.create(msg.channel_id, result)

      String.starts_with?(msg.content, "!cep") ->
        result = get_cep_data(validate_cep_command(msg.content))
        Api.Message.create(msg.channel_id, result)

      true ->
        :ignore
    end
  end

  def validate_cep_command(content) do
    command = String.split(content, " ")

    case command do
      ["!cep", cep_value] -> {:ok, cep_value}
      _ -> :error
    end
  end

  def get_cep_data({:ok, cep_value}) do
    result = HTTPoison.get("viacep.com.br/ws/#{cep_value}/json/")

    case result do
      {:ok, response} ->
        {:ok, json} = JSON.decode(response.body)

        "#{json["logradouro"]}, #{json["bairro"]}, #{json["localidade"]}, #{json["uf"]}"

      _ ->
        "Comando inválido. Use: **!cep numero_cep**"
    end
  end

  def get_cep_data(_) do
    "Comando inválido. Use: **!cep numero_cep**"
  end

  def validate_ppt_command(content) do
    command = String.split(content, " ")

    case command do
      ["!ppt", player_choice] when player_choice in ["pedra", "papel", "tesoura"] ->
        {:ok, player_choice}

      _ ->
        :error
    end
  end

  def return_ppt_result({:ok, player_choice}) do
    bot_choice = Enum.random(["pedra", "papel", "tesoura"])
    IO.puts("Bot: #{bot_choice}, Player: #{player_choice}")

    cond do
      bot_choice == player_choice -> "Houve um empate! :face_with_spiral_eyes:"
      bot_choice == ["pedra"] and player_choice == ["tesoura"] -> "O bot venceu! :star_struck:"
      bot_choice == ["tesoura"] and player_choice == ["papel"] -> "O bot venceu! :star_struck:"
      bot_choice == ["papel"] and player_choice == ["pedra"] -> "O bot venceu! :star_struck:"
      true -> "Você venceu! :sob:"
    end
  end

  def return_ppt_result(_) do
    "Comando inválido. Use: **!ppt pedra|papel|tesoura**"
  end
end
