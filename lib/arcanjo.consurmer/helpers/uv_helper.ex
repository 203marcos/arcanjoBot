defmodule Arcanjo.Consurmer.Helpers.UVHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = validate_uv_command(msg.content) |> get_uv_data()
    Api.Message.create(msg.channel_id, result)
  end

  defp validate_uv_command(content) do
    case String.split(content, " ") do
      ["!uvSun", lat, lng] -> {:ok, lat, lng}
      _ -> :error
    end
  end

  defp get_uv_data({:ok, lat, lng}) do
    api_key = System.get_env("OPENUV_API_KEY")
    url = "https://api.openuv.io/api/v1/uv?lat=#{lat}&lng=#{lng}"

    headers = [{"x-access-token", api_key}, {"Content-Type", "application/json"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"result" => result}} ->
            uv_max = result["uv_max"]
            uv_min = result["uv"]
            uv_avg = Float.round((uv_max + uv_min) / 2, 2)

            """
            **Dados UV Simplificados:**
            - **UV Máximo:** #{uv_max}
            - **UV Mínimo:** #{uv_min}
            - **UV Médio:** #{uv_avg}
            """

          _ ->
            "Erro ao processar os dados da API."
        end

      _ ->
        "Erro ao conectar à API OpenUV."
    end
  end

  defp get_uv_data(_) do
    "Comando inválido. Use: **!uvSun latitude longitude**"
  end
end
