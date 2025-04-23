import Config

# Função para carregar variáveis do .env
defmodule EnvLoader do
  def load_env(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.each(fn line ->
      case String.split(line, "=", parts: 2) do
        [key, value] -> System.put_env(key, value)
        _ -> :ok
      end
    end)
  end
end

# Verifica se o arquivo .env existe antes de carregá-lo
if File.exists?("config/.env") do
  EnvLoader.load_env("config/.env")
end

# Configuração do Nostrum
config :nostrum,
  token: System.get_env("NOSTRUM_TOKEN"),
  gateway_intents: :all,
  ffmpeg: nil
