up:
	docker compose up --build

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose down && docker compose up --build

build:
	docker compose build --no-cache

prod-up:
	docker compose -f docker-compose.yml up --build

prod-down:
	docker compose -f docker-compose.yml down

prod-build:
	docker compose -f docker-compose.yml build

lint:
	docker compose up -d drawio_export_api
	docker compose exec drawio_export_api poetry run black --check . || (docker compose down && false)
	docker compose down

test: keys
	docker compose up -d drawio_export_api
	docker compose exec drawio_export_api poetry run pytest || (docker compose down && false)
	docker compose down

bash:
	docker compose exec drawio_export_api bash

status:
	docker compose ps

keys:
	mkdir -p nginx/certs
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout nginx/certs/privkey.pem \
		-out nginx/certs/fullchain.pem \
		-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=LocalDev/CN=localhost" \
		-addext "subjectAltName=DNS:localhost"

publish:
	docker build -t hirvi0/drawio-export-api:v$$(poetry version --short) .
	docker push hirvi0/drawio-export-api:v$$(poetry version --short)
