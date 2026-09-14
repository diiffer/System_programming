#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="system-programming-fasm"
CONTAINER_NAME="system-programming-fasm"
CONTAINER_WORKDIR="/system_programming"

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Ошибка: этот скрипт предназначен для macOS." >&2
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew не найден. Устанавливаю Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            echo "Homebrew установился, но команда brew не найдена." >&2
            exit 1
        fi
    fi

    echo "Docker не найден. Устанавливаю Docker Desktop через Homebrew..."
    brew install --cask docker
fi

if ! docker info >/dev/null 2>&1; then
    echo "Запускаю Docker Desktop..."
    open -a Docker

    for _ in {1..60}; do
        if docker info >/dev/null 2>&1; then
            break
        fi
        sleep 2
    done
fi

if ! docker info >/dev/null 2>&1; then
    echo "Не удалось дождаться запуска Docker Desktop." >&2
    exit 1
fi

if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "Образ не найден. Собираю его..."
    docker build \
        --platform linux/amd64 \
        --tag "$IMAGE_NAME" \
        --file - \
        "$SCRIPT_DIR" <<'DOCKERFILE'
FROM --platform=linux/amd64 ubuntu:22.04

RUN apt-get update && apt-get install -y \
    fasm \
    gdb \
    gcc \
    gcc-multilib \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /asm

CMD ["/bin/bash"]
DOCKERFILE
fi

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    if [[ "$(docker inspect --format '{{.State.Running}}' "$CONTAINER_NAME")" == "true" ]]; then
        docker exec --interactive --tty "$CONTAINER_NAME" /bin/bash
    else
        docker start --attach --interactive "$CONTAINER_NAME"
    fi
else
    docker run --interactive --tty \
        --name "$CONTAINER_NAME" \
        --platform linux/amd64 \
        --volume "$SCRIPT_DIR:$CONTAINER_WORKDIR" \
        --workdir "$CONTAINER_WORKDIR" \
        "$IMAGE_NAME" \
        /bin/bash
fi
