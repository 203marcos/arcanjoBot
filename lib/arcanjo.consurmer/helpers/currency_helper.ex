defmodule Arcanjo.Consurmer.Helpers.CurrencyHelper do
  alias Nostrum.Api

  @api_url "https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL"

  def handle(msg) do
    case validate_currency_command(msg.content) do
      {:ok, currency} ->
        result = fetch_currency_data(currency)
        Api.Message.create(msg.channel_id, result)

      :error ->
        Api.Message.create(msg.channel_id, "Comando inválido. Use: **!dolar**, **!euro** ou **!btc**.")
    end
  end

  defp validate_currency_command(content) do
    case String.downcase(content) do
      "!dolar" -> {:ok, "USDBRL"}
      "!euro" -> {:ok, "EURBRL"}
      "!btc" -> {:ok, "BTCBRL"}
      _ -> :error
    end
  end

  defp fetch_currency_data(currency) do
    case HTTPoison.get(@api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} ->
            format_currency_response(data[currency])

          _ ->
            "Erro ao processar os dados da API."
        end

      _ ->
        "Erro ao conectar à API de cotações."
    end
  end

  defp format_currency_response(%{"name" => name, "bid" => bid}) do
    case Float.parse(bid) do
      {value, _} ->
        cond do
          value > 100 ->
            "#{name}: R$#{bid} - Isso é coisa de burguês safado! 😡"

          value > 6 ->
            "#{name}: R$#{bid} - Nossa, tá caro isso hein! 😱"

          true ->
            "#{name}: R$#{bid} - Tá tranquilo, dá pra comprar. 😌"
        end

      :error ->
        "Erro ao converter o valor da cotação."
    end
  end

  defp format_currency_response(_), do: "Erro ao formatar os dados da cotação."
end
