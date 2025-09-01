FROM rlespinasse/drawio-export:v4.37.0

ENV PYTHON_VERSION=3.13.0 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VERSION=2.1.2 \
    PYTHONPATH=/app/src \
    ENV=development

# Create user and install dependencies required by Python (+ Nginx and Supervisor)
RUN groupadd --gid 1000 appuser && \
    useradd --uid 1000 --gid appuser --shell /bin/bash --create-home appuser && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev \
        libxmlsec1-dev libffi-dev liblzma-dev nginx supervisor && \
    # Install Python
    curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j"$(nproc)" && \
    make altinstall && \
    ln -sf /usr/local/bin/python3.13 /usr/bin/python && \
    ln -sf /usr/local/bin/pip3.13 /usr/bin/pip && \
    # Install Poetry
    pip install --no-cache-dir "poetry==$POETRY_VERSION" && \
    # Remote installation dependencies
    apt-get purge -y --auto-remove \
        make build-essential wget curl libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev \
        libxmlsec1-dev libffi-dev liblzma-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* Python-${PYTHON_VERSION}* && \
    # Create directories and set permissions
    mkdir -p \
        /tmp/nginx/body \
        /tmp/nginx/proxy \
        /tmp/nginx/fastcgi \
        /tmp/nginx/uwsgi \
        /tmp/nginx/scgi \
        /var/log/nginx \
        /etc/nginx/certs \
        /etc/supervisor/conf.d && \
    chown -R appuser:appuser \
        /var/log/nginx \
        /etc/nginx \
        /etc/supervisor \
        /tmp/nginx

WORKDIR /app

# Drawio desktop headless mod:
COPY --chown=appuser:appuser docker-drawio-desktop-headless/entrypoint.sh /opt/drawio-desktop/entrypoint.sh
RUN chmod u+x /opt/drawio-desktop/entrypoint.sh

# Copy sources
COPY --chown=appuser:appuser supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chown=appuser:appuser nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=appuser:appuser nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --chown=appuser:appuser pyproject.toml poetry.lock* /app/
COPY --chown=appuser:appuser . /app

USER appuser

# If dev setup, we install dev dependencies
RUN if [ "$ENV" = "production" ]; then \
      poetry install --no-root --only main --without dev; \
    else \
      poetry install --no-root; \
    fi

# Start Uvicorn and Nginx
ENTRYPOINT ["/usr/bin/supervisord"]
