FROM fedora:34
LABEL maintainer="Hallas, l.l.c"

ENV PYTHONUNBUFFERED 1
# Allows instant viewing of logs
EXPOSE 8000
ARG DEV=false
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

# Create a virtual environment and install dependencies
# virtualenv is a tool to create isolated Python environments
# allows consistent installation of packages, incase the base python image changes
# docker-compose will set the DEV to true for developement
RUN yum install python postgresql-devel -y && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = true ] ; then \
        pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/* && \
    useradd \
    --password  ""\
    django 

ENV PATH="/py/bin:${PATH}"

USER django