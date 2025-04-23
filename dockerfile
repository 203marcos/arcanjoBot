# Use a imagem oficial do Elixir 1.18
FROM elixir:1.18

# Instala pacotes do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    inotify-tools \
    git \
    ffmpeg \
    && apt-get clean

# Configure o diretório de trabalho
WORKDIR /app

# Copia e instala dependências
COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

# Copia o restante do projeto
COPY . .

# Compila o projeto
RUN mix compile

# Define variável de ambiente para evitar problemas com o tty
ENV TERM xterm

# Exponha a porta 8080 (mesmo que o bot não use HTTP, é uma boa prática)
EXPOSE 8080

# Comando final para rodar o bot
CMD ["mix", "run", "--no-halt"]