FROM edgedb/edgedb-cli as edgedb-cli
FROM python:3.11-slim-buster as play

WORKDIR /usr/src/app

ENV DEBIAN_FRONTEND=noninteractive \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  PYTHONPATH="${PYTHONPATH}:/app" \
  PATH="/usr/src/app/scripts:${PATH}"

RUN pip install -U pip poetry \
    && poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock /usr/src/app/
RUN poetry install -n --without=dev

COPY scripts /usr/src/app/scripts/
RUN chmod +x /usr/src/app/scripts/*

COPY --from=edgedb-cli /usr/bin/edgedb /usr/bin/
COPY dbschema /usr/src/app/dbschema/
COPY edgedb.toml /usr/src/app/

COPY app /usr/src/app/app

ENTRYPOINT [ "run.sh" ]
