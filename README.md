# RAGEmbed 🚀

[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://docs.docker.com/compose/)
[![Node.js](https://img.shields.io/badge/Node.js-v20-green.svg)](https://nodejs.org/)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-black.svg)](https://github.com/ElephantTower/RAGEmbed)

RAGEmbed is a modern, full-stack application that leverages embeddings for intelligent search capabilities tailored to PascalABC documentation.

> **Quick Start**: Clone, run `make all`, and you're live! 🌟

## 🛠️ Prerequisites

- Docker & Docker Compose (v2+)
- Git
- Node.js (v20+) — optional for local dev
- Make (on Linux/Mac; Git Bash on Windows)

**On Windows?** Use Git Bash or WSL for best results.

## 📦 Installation

1. **Clone the Main Repo**:
   ```bash
   git clone https://github.com/ElephantTower/RAGEmbed.git
   cd RAGEmbed
   ```

2. **Run Setup**:
   ```bash
   make all
   ```
   This will:
   - Clone sub-repos (frontend & backend).
   - Generate `.env` files from examples.
   - Build Docker images.
   - Start services in detached mode.

   **Pro Tip**: If you need to tweak configs first, run `make build-proj` instead (builds without starting).

## 🚀 Usage

### Start the App
- **Background Mode** (recommended for prod/dev):
   ```bash
   make up
   ```
   Access at [http://localhost](http://localhost) (Nginx on port 80).

- **Foreground Mode** (for logs/debug):
   ```bash
   make up-fg
   ```
   Stop with Ctrl+C.

### Stop & Clean
- Stop services:
   ```bash
   make down
   ```
- Full cleanup (repos + volumes):
   ```bash
   make clean-all
   ```
- Docker-only cleanup:
   ```bash
   make clean-docker
   ```

### View Logs
```bash
docker compose logs -f  # Or specify service: docker compose logs -f backend
```

### Available Commands
Run `make help` for a full list:

| Command          | Description                  |
|------------------|------------------------------|
| `make all`     | Full setup & start           |
| `make build-proj` | Clone, init & build images   |
| `make build`   | Build images only            |
| `make up`      | Start in background          |
| `make up-fg`   | Start in foreground          |
| `make down`    | Stop services                |
| `make clean-all` | Full cleanup (repos + Docker)|
| `make clean-docker` | Docker cleanup only      |

## 🔧 Configuration

### Environment Variables
- **Root `.env`** (create via `make init-root-env`):
   ```
   APP_PORT=3000
   POSTGRES_USER="postgres"
   POSTGRES_PASSWORD="postgres"
   POSTGRES_DB="ragembed"
   MODEL_NAMES="embeddinggemma nomic-embed-text snowflake-arctic-embed:m"
   ```

- **Backend `.env`** (auto-generated; edit manually):
  - Change `ADMIN_SECRET=your-strong-secret` for auth.

**Security Note**: Never commit `.env` files! Add to `.gitignore`.

### Customizing Ollama
- Models download on first run (may take 5–30 min based on size/network).
- Edit `./pull-llama-model.sh` for custom pull logic.
- Healthcheck waits up to ~20 min — adjust `start_period` in `docker-compose.yml` if needed.

## 📁 Project Structure

```
RAGEmbed/
├── Makefile          # Orchestration magic
├── docker-compose.yml # Services config
├── nginx.conf        # Proxy & static serving
├── .env-example      # Root env template
├── init-scripts/     # Ollama init scripts
├── frontend/         # Cloned Svelte app
├── backend/          # Cloned NestJS API
└── README.md         # You're reading it! 😎
```

**Built with ❤️ by ElephantTower** | Questions? [Open an Issue](https://github.com/ElephantTower/RAGEmbed/issues)  
*Last updated: October 28, 2025*
