FROM python:3.10

ENV PYTHONUNBUFFERED 1

ARG DOCKERIZE_VERSION=v0.6.1

# Install dockerize
RUN apt-get update && apt-get install -y wget \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && apt-get install -y wkhtmltopdf

# Install GeoDjango dependencies
RUN apt-get update && apt-get install -y binutils libproj-dev
RUN apt-get update && apt-get install -y libgeoip1 librabbitmq-dev python3-gdal
RUN apt-get update && apt-get install -y libpq-dev libgdal-dev
RUN apt-get update && apt-get install -y gdal-bin && rm -rf /var/lib/apt/lists/*

#RUN groupadd -r django \
#    && useradd -r -g django django

# Requirements are installed here to ensure they will be cached.
COPY ./requirements /requirements
COPY ./src /src
WORKDIR src

EXPOSE 8000

RUN pip install --upgrade pip && pip install --no-cache-dir -r /requirements/development.txt \
    && rm -rf /requirements

ENV PATH="/py/bin:$PATH"
