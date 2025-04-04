# pip dependencies install stage

ARG PYTHON_VERSION=3.11

# No ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1 needed since we are installing directly in the final stage.

FROM python:${PYTHON_VERSION}-slim-bookworm
# LABEL org.opencontainers.image.source="https://github.com/dgtlmoon/changedetection.io"

RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    gcc \
    libc-dev \
    libffi-dev \
    libjpeg-dev \
    libssl-dev \
    libxslt-dev \
    make \
    zlib1g-dev \
    libxslt1.1 \
    poppler-utils \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY requirements.txt /requirements.txt
RUN pip install --extra-index-url https://www.piwheels.org/simple --target=/usr/local -r /requirements.txt \
    && pip install --target=/usr/local playwright~=1.48.0 \
    || echo "WARN: Failed to install Playwright. The application can still run, but the Playwright option will be disabled."

# https://stackoverflow.com/questions/58701233/docker-logs-erroneously-appears-empty-until-container-stops
ENV PYTHONUNBUFFERED=1

RUN [ ! -d "/datastore" ] && mkdir /datastore

# Re #80, sets SECLEVEL=1 in openssl.conf to allow monitoring sites with weak/old cipher suites
RUN sed -i 's/^CipherString = .*/CipherString = DEFAULT@SECLEVEL=1/' /etc/ssl/openssl.cnf

# Add dependencies to PYTHONPATH
ENV PYTHONPATH=/usr/local

EXPOSE 5000

# The actual flask app module
COPY changedetectionio /app/changedetectionio
# Starting wrapper
COPY changedetection.py /app/changedetection.py

# Github Action test purpose(test-only.yml).
# On production, it is effectively LOGGER_LEVEL=''.
ARG LOGGER_LEVEL=''
ENV LOGGER_LEVEL "$LOGGER_LEVEL"

WORKDIR /app
CMD ["python", "./changedetection.py", "-d", "/datastore"]
