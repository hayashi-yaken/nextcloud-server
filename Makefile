COMPOSE = docker compose
PROJECT = nextcloud

.PHONY: up down clean-volumes restart

##  コンテナの起動
up:
	$(COMPOSE) up -d

## コンテナの停止
down:
	$(COMPOSE) down

## ボリュームの削除
clean-volumes:
	$(COMPOSE) down -v
	@if docker volume ls -q | grep '^nextcloud-' >/dev/null; then \
		docker volume rm $$(docker volume ls -q | grep '^nextcloud-'); \
	else \
		echo "No nextcloud-related volumes to remove."; \
	fi

## 再起動
restart:
	$(COMPOSE) restart
