FROM python:3.11-slim-bullseye as build
LABEL maintainer="Gerardo Ramos"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
build-essential gcc
WORKDIR /usr/app
RUN python -m venv /usr/app/venv
ENV PATH="/usr/app/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install -r requirements.txt


FROM python:3.11-slim-bullseye
LABEL maintainer="Gerardo Ramos"

RUN groupadd -g 69420 python && \
    useradd -r -u 69420 -g python python
RUN mkdir /usr/app && chown python:python /usr/app
WORKDIR /usr/app
COPY --chown=python:python --from=build /usr/app/venv ./venv
COPY --chown=python:python ./src/app .
USER 69420
ENV PATH="/usr/app/venv/bin:$PATH"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost/healthcheck