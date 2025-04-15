defmodule Arcanjo.Consurmer.Helpers.JokeHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = get_joke()
    Api.Message.create(msg.channel_id, result)
  end

  defp get_joke() do
    url = "https://v2.jokeapi.dev/joke/Programming"

    case HTTPoison.get(url, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"type" => "single", "joke" => joke}} -> joke
          {:ok, %{"type" => "twopart", "setup" => setup, "delivery" => delivery}} ->
            "#{setup} - #{delivery}"

          _ ->
            "Erro ao processar os dados da API da piada."
        end

      _ ->
        "Erro ao conectar à API Joke API."
    end
  end
end
