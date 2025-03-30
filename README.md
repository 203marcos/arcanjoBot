# Arcanjo Bot

Arcanjo is a Discord bot built using Elixir and the Nostrum library. This bot is designed to interact with the Discord API and can be customized to perform various tasks.

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd arcanjo
   ```

2. **Install Dependencies**
   Make sure you have Elixir and Erlang installed. Then, run the following command to install the dependencies:
   ```bash
   mix deps.get
   ```

3. **Configure Environment Variables**
   Create a `.env` file in the `config` directory and add your Discord bot token:
   ```
   NOSTRUM_TOKEN=your_discord_bot_token
   ```

4. **Run the Bot**
   You can start the bot using the following command:
   ```bash
   mix run --no-halt
   ```

## Usage

Once the bot is running, it will connect to your Discord server and start listening for events. You can customize its behavior by modifying the `lib/arcanjo/bot.ex` file.

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements for the bot.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.