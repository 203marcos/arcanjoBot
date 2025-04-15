defmodule Arcanjo.Consurmer.Helpers.CEPHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = validate_cep_command(msg.content) |> get_cep_data()
    Api.Message.create(msg.channel_id, result)
  end

  defp validate_cep_command(content) do
    case String.split(content, " ") do
      ["!cep", cep_value] -> {:ok, cep_value}
      _ -> :error
    end
  end

  defp get_cep_data({:ok, cep_value}) do
    result = HTTPoison.get("https://viacep.com.br/ws/#{cep_value}/json/")

    case result do
      {:ok, response} ->
        {:ok, json} = Jason.decode(response.body)
        "#{json["logradouro"]}, #{json["bairro"]}, #{json["localidade"]}, #{json["uf"]}"

      _ ->
        "Erro ao buscar informações do CEP."
    end
  end

  defp get_cep_data(_) do
    "Comando inválido. Use: **!cep numero_cep**"
  end
end
