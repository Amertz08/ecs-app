FROM python:3.7-slim-buster

# TODO: create a non root user for the app to run as

# Install c dependencies first as these rarely change and we can take advantage
#  of caching to keep builds quick.
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*
    # rm -rf cleans up a bunch of files apt-get leaves during installs that are unnecessary.

RUN mkdir /etc/uwsgi
RUN mkdir /code
WORKDIR /code

# By copying requirements over prior to upgrading pip/wheel/setuptools
#  we will cause those packages to be upgraded every time requirements.txt changes
#  if requirements.txt doesn't change then the subsequent layers will stay cached
#  an builds will be quick.
COPY src/requirements.txt .
RUN python3.7 -m pip install --upgrade \
    pip \
    setuptools \
    wheel
RUN python3.7 -m pip install -r requirements.txt

# This is almost alway going to invalidate the Docker cache so we should try and put it last
#  the commands that follow may get invalidated but their short enough it really doesn't matter.
COPY src .

EXPOSE 5000
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["run"]
