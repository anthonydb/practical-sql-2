## Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition

### pgAdmin's AI Assistant

In early 2026, pgAdmin introduced an AI Assistant feature that can generate SQL and also check your databases for performance and security issues. To use the feature, you first need to configure an AI provider. Once you do, the pgAdmin Query Tool will display an AI Assistant tab, and a collection of AI reports become available under the app's Tools menu.

Currently, pgAdmin allows use of one of four AI providers:

- Anthropic: Cloud-based, paid API (Claude). Point pgAdmin at the Anthropic API (defaulting to `https://api.anthropic.com/v1`), supply an API key file, and pick from available Claude models. Using a custom API URL field, you can also point it at any Anthropic-compatible proxy or intermediary.

- OpenAI: Also cloud-based, requiring an API key. Defaults to `https://api.openai.com/v1` and lets you select from available GPT models. Set a custom URL to use any OpenAI-compatible API provider — such as LiteLLM, LM Studio, or EXO — by including the `/v1` path prefix if required. 

- Ollama: A tool for running open-source LLMs on your own machine. pgAdmin defaults to `http://localhost:11434` and lets you pick from whatever models you have pulled locally — things like Llama 2 or Mistral. A "no cloud, no API key, runs on your hardware" option, which is appealing if you have data privacy concerns or want to avoid per-token costs.

- Docker Model Runner: Available in Docker Desktop 4.40+ and runs at `http://localhost:12434` by default. If you're already running pgAdmin in Docker, this may be a convenient pairing since everything lives in the same environment.

### Setting it Up

To set an AI provider, visit `Preferences > AI`. Complete instructions are available at [https://www.pgadmin.org/docs/pgadmin4/latest/preferences.html#the-ai-node](https://www.pgadmin.org/docs/pgadmin4/latest/preferences.html#the-ai-node)

### Query Tool Usage

With an AI provider configured, you should see an `AI Assistant` tab when using the Query Tool. In that tab, you can chat with the AI and ask it to write SQL or report back on database objects.

### AI Reports Usage

Under `Tools > AI Reports` are three options. Per the [official documentation](https://www.pgadmin.org/docs/pgadmin4/latest/ai_tools.html):

- Security Reports analyze your PostgreSQL server, database, or schema for potential security vulnerabilities and configuration issues.

- Performance Reports analyze query performance, configuration settings, and provide optimization recommendations.

- Design Review Reports analyze your database schema structure and suggest improvements for normalization, naming conventions, and best practices.

