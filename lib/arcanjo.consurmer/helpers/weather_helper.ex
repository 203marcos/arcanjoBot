defmodule Arcanjo.Consurmer.Helpers.WeatherHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = validate_weather_command(msg.content) |> get_weather()
    Api.Message.create(msg.channel_id, result)
  end

  defp validate_weather_command(content) do
    case String.split(content, " ") do
      ["!clima", city] -> {:ok, city}
      _ -> :error
    end
  end

  defp get_weather({:ok, city}) do
    api_key = System.get_env("OPENWEATHER_API_KEY")
    url = "https://api.openweathermap.org/data/2.5/weather?q=#{URI.encode(city)}&appid=#{api_key}&units=metric&lang=pt_br"

    case HTTPoison.get(url, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"main" => %{"temp" => temp}, "weather" => [%{"description" => desc}]}} ->
            """
            🌤️ **Clima em #{String.capitalize(city)}:**
            - **Temperatura:** #{temp}°C
            - **Condições:** #{desc}
            """
          _ -> "Erro ao processar os dados do clima."
        end

      _ ->
        "Erro ao conectar à API OpenWeatherMap."
    end
  end

  defp get_weather(_) do
    "Comando inválido. Use: **!clima <cidade>**"
  end
end
