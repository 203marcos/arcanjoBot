defmodule Arcanjo.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Arcanjo.Consurmer.Helpers.{
    BasicHelper,
    CEPHelper,
    PPTHelper,
    UVHelper,
    WeatherHelper,
    CatHelper,
    JokeHelper,
    DiceHelper,
    CurrencyHelper,
    HolidayHelper
  }

  def handle_event({:MESSAGE_CREATE, msg, _ws_status}) do
    cond do
      String.starts_with?(msg.content, "!ping") ->
        BasicHelper.handle(msg)

      String.starts_with?(msg.content, "!oie") ->
        BasicHelper.handle(msg)

      String.starts_with?(msg.content, "!oldcommands") ->
        embed = %{
          title: "Comandos Antigos",
          description: "Aqui estão os comandos antigos disponíveis:",
          color: 0x0074E7,
          fields: [
            %{
              name: "!ppt",
              value: "Use este comando para jogar pedra, papel ou tesoura.",
              inline: true
            },
            %{
              name: "!cep",
              value: "Use este comando para buscar informações de um CEP. Exemplo: `!cep 01001000`.",
              inline: true
            }
          ],
          author: %{name: "ArcanjoBot"}
        }

        Api.Message.create(msg.channel_id, %{embed: embed})

      String.starts_with?(msg.content, "!newcommands") ->
        embed = %{
          title: "Novos Comandos",
          description: "Aqui estão os novos comandos disponíveis:",
          color: 0x0074E7,
          fields: [
            %{
              name: "!uvSun",
              value: "Use este comando para obter dados UV de uma localização. Exemplo: `!uvSun <latitude> <longitude>`.",
              inline: true
            },
            %{
              name: "!miau",
              value: "Use este comando para receber uma imagem de um gato aleatório.",
              inline: true
            },
            %{
              name: "!piadocas",
              value: "Use este comando para receber uma piada de programação.",
              inline: true
            },
            %{
              name: "!dado",
              value: "Use este comando para rolar um dado e decidir seu destino.",
              inline: true
            },
            %{
              name: "!clima",
              value: "Use este comando para obter informações sobre o clima de uma cidade. Exemplo: `!clima São Paulo`.",
              inline: true
            },
            %{
              name: "!dolar",
              value: "Use este comando para saber a cotação do dólar.",
              inline: true
            },
            %{
              name: "!euro",
              value: "Use este comando para saber a cotação do euro.",
              inline: true
            },
            %{
              name: "!btc",
              value: "Use este comando para saber a cotação do bitcoin.",
              inline: true
            },
            %{
              name: "!feriados",
              value: "Use este comando para listar os feriados nacionais do Brasil de um ano específico. Exemplo: `!feriados 2025`.",
              inline: true
            }
          ],
          author: %{name: "ArcanjoBot"}
        }

        Api.Message.create(msg.channel_id, %{embed: embed})

      String.starts_with?(msg.content, "!ppt") ->
        PPTHelper.handle(msg)

      String.starts_with?(msg.content, "!cep") ->
        CEPHelper.handle(msg)

      String.starts_with?(msg.content, "!uvSun") ->
        UVHelper.handle(msg)

      String.starts_with?(msg.content, "!miau") ->
        CatHelper.handle(msg)

      String.starts_with?(msg.content, "!piadocas") ->
        JokeHelper.handle(msg)

      String.starts_with?(msg.content, "!dado") ->
        DiceHelper.handle(msg)

      String.starts_with?(msg.content, "!clima") ->
        WeatherHelper.handle(msg)

      String.starts_with?(msg.content, "!dolar") ->
        CurrencyHelper.handle(msg)

      String.starts_with?(msg.content, "!euro") ->
        CurrencyHelper.handle(msg)

      String.starts_with?(msg.content, "!btc") ->
        CurrencyHelper.handle(msg)

      String.starts_with?(msg.content, "!feriados") ->
        HolidayHelper.handle(msg)

      true ->
        :ignore
    end
  end
end
