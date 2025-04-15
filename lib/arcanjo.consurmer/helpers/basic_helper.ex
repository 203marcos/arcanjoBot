defmodule Arcanjo.Consurmer.Helpers.BasicHelper do
  alias Nostrum.Api

  def handle(msg) do
    cond do
      String.starts_with?(msg.content, "!ping") -> handle_ping(msg)
      String.starts_with?(msg.content, "!oie") -> handle_oie(msg)
      true -> :ignore
    end
  end

  defp handle_ping(msg) do
    Api.Message.create(msg.channel_id, "pong!")
  end

  defp handle_oie(msg) do
    embed = %{
      title: "Olá",
      description: "Tudo bem com você? Segue a lista de categorias de comandos disponíveis:",
      color: 0x0074E7,
      fields: [
        %{name: "!oldcommands", value: "Veja os comandos antigos disponíveis.", inline: true},
        %{name: "!newcommands", value: "Veja os novos comandos disponíveis.", inline: true}
      ],
      author: %{name: "ArcanjoBot"}
    }

    Api.Message.create(msg.channel_id, %{embed: embed})
  end
end
