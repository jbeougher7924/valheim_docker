#!/usr/bin/env bash
# valheim.sh — simple control script for Valheim Docker stack
# Default stack dir: /mnt/llm_models/containers/valheim_docker
# Requires: docker (with compose), and your user can run sudo docker

set -Eeuo pipefail

COMPOSE_DIR="${COMPOSE_DIR:-/mnt/llm_models/containers/valheim_docker}"
CONTAINER="${CONTAINER:-valheim}"
COMPOSE=(sudo docker compose)

usage() {
  cat <<'EOF'
Usage: valheim.sh <start|stop|restart|update|logs|status|help>

Commands:
  start     Start (or create) the stack in the background
  stop      Stop and remove containers (volumes/data are preserved)
  restart   Restart only the Valheim container
  update    Pull latest image(s) and recreate containers
  logs      Follow server logs (Ctrl-C to quit)
  status    Show compose status
  help      Show this help

Env overrides:
  COMPOSE_DIR=/path/to/compose   (default: /mnt/llm_models/containers/valheim_docker)
  CONTAINER=valheim              (container name in docker-compose.yml)
EOF
}

cmd="${1:-help}"

# Always operate from the compose directory
cd "$COMPOSE_DIR"

case "$cmd" in
  start)
    "${COMPOSE[@]}" up -d
    ;;
  stop)
    "${COMPOSE[@]}" down
    ;;
  restart)
    "${COMPOSE[@]}" restart "$CONTAINER"
    ;;
  update)
    "${COMPOSE[@]}" pull && "${COMPOSE[@]}" up -d
    ;;
  logs)
    sudo docker logs -f "$CONTAINER"
    ;;
  status)
    "${COMPOSE[@]}" ps
    ;;
  help|-h|--help|"")
    usage
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
