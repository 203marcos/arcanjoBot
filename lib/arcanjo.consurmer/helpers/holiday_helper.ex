defmodule Arcanjo.Consurmer.Helpers.HolidayHelper do
  alias Nostrum.Api

  @api_url "https://calendarific.com/api/v2/holidays"
  @api_key System.get_env("HOLIDAY_API_KEY") # Busca a chave do .env

  def handle(msg) do
    case validate_holiday_command(msg.content) do
      {:ok, year} ->
        result = fetch_holidays(year)
        Api.Message.create(msg.channel_id, result)

      :error ->
        Api.Message.create(msg.channel_id, "Comando inválido. Use: **!feriados <ano>**.")
    end
  end

  defp validate_holiday_command(content) do
    case String.split(content, " ") do
      ["!feriados", year] ->
        if Regex.match?(~r/^\d{4}$/, year) do
          {:ok, year}
        else
          :error
        end

      _ ->
        :error
    end
  end

  defp fetch_holidays(year) do
    url = "#{@api_url}?api_key=#{@api_key}&country=BR&year=#{year}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"response" => %{"holidays" => holidays}}} ->
            format_holidays(holidays)

          _ ->
            "Erro ao processar os dados da API."
        end

      _ ->
        "Erro ao conectar à API de feriados."
    end
  end

  defp format_holidays(holidays) do
    holidays
    |> Enum.map(fn %{"name" => name, "date" => %{"iso" => date}} ->
      "- #{name}: #{date}"
    end)
    |> Enum.join("\n")
    |> (&"Feriados:\n#{&1}").()
  end
end
