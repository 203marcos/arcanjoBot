# Arcanjo Bot

Arcanjo is a Discord bot built with Elixir and the Nostrum library. It interacts with the Discord API and can be customized to perform various tasks.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd arcanjo
```

### 2. Install Dependencies

Ensure you have Elixir and Erlang installed. Then, install the dependencies:

```bash
mix deps.get
```

### 3. Configure Environment Variables

Create a `.env` file in the `config` directory and add your Discord bot token:

```env
NOSTRUM_TOKEN=your_discord_bot_token
```

### 4. Run the Bot

Start the bot with:

```bash
mix run --no-halt
```

### 5. Using Docker

You can also run the bot using Docker. Follow these steps:

#### Build the Docker Image

```bash
docker build -t arcanjo-bot .
```

#### Run the Docker Container

```bash
docker run --env-file=config/.env arcanjo-bot
```

#### Using Docker Compose

Alternatively, you can use Docker Compose for easier management. Create a `docker-compose.yml` file:

```yaml
version: "3.8"
services:
    arcanjo-bot:
        build: .
        env_file:
            - config/.env
        restart: unless-stopped
```

Run the bot with:

```bash
docker-compose up -d
```

## Usage

Once running, the bot will connect to your Discord server and listen for events. Customize its behavior by editing the `lib/arcanjo/bot.ex` file.

## Contributing

Contributions are welcome! Submit issues or pull requests to suggest improvements or new features.


