# Use a imagem oficial do Elixir 1.18
FROM elixir:1.18

# Instale dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    inotify-tools \
    git \
    ffmpeg \
    && apt-get clean

# Configure o diretório de trabalho
WORKDIR /app

# Copie apenas os arquivos necessários para instalar as dependências primeiro (cache otimizado)
COPY mix.exs mix.lock ./

# Instale as dependências do Elixir
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

# Copie o restante do código do projeto
COPY . .

# Compile o projeto
RUN mix compile

# Exponha a porta usada pelo bot (se necessário)
EXPOSE 4000

# Comando para iniciar o bot
CMD ["mix", "run", "--no-halt"]