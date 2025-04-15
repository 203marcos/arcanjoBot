defmodule Arcanjo.Consurmer.Helpers.CatHelper do
  alias Nostrum.Api

  def handle(msg) do
    result = get_cat_image()
    Api.Message.create(msg.channel_id, result)
  end

  defp get_cat_image() do
    url = "https://api.thecatapi.com/v1/images/search"

    case HTTPoison.get(url, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, [cat_data | _]} ->
            image_url = cat_data["url"]
            width = cat_data["width"]
            height = cat_data["height"]

            """
            **Aqui está um gato para você!** 🐱
            - **URL da Imagem:** #{image_url}
            - **Largura:** #{width}px
            - **Altura:** #{height}px
            """

          _ ->
            "Erro ao processar os dados da API do gato."
        end

      _ ->
        "Erro ao conectar à API The Cat API."
    end
  end
end
