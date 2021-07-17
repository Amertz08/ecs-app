FROM python:3.7-slim-buster

RUN mkdir /code
WORKDIR /code

COPY src/requirements.txt .
RUN python3.7 -m pip install --upgrade \
    pip \
    setuptools \
    wheel
RUN python3.7 -m pip install -r requirements.txt

COPY src .

EXPOSE 5000
CMD ["python3.7", "main.py"]
