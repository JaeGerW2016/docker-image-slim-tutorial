# my-app:v1
#FROM python:3.8.0-slim
#COPY . /app
#RUN apt-get update \
#&& apt-get install gcc -y \
#&& apt-get clean
#WORKDIR app
#RUN pip install --user --default-timeout=100 -r requirements.txt -i https://pypi.doubanio.com/simple/
#ENTRYPOINT uvicorn main:app --reload --host 0.0.0.0 --port 8080

# my-app:v2
#FROM python:3.8.0-slim
#RUN apt-get update \
#&& apt-get install gcc -y \
#&& apt-get clean
#COPY requirements.txt /app/requirements.txt
#WORKDIR app
#RUN pip install --user --default-timeout=100 -r requirements.txt -i https://pypi.doubanio.com/simple/
#COPY . /app
#ENTRYPOINT uvicorn main:app --reload --host 0.0.0.0 --port 1234

# my-app:v3
# Here is the build image
FROM python:3.8.0-slim as builder
RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean
COPY requirements.txt /app/requirements.txt
WORKDIR app
RUN pip install --user --default-timeout=100 -r requirements.txt -i https://pypi.doubanio.com/simple/
COPY . /app
# Here is the production image
FROM python:3.8.0-slim as app
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/main.py /app/main.py
WORKDIR app
ENV PATH=/root/.local/bin:$PATH
ENTRYPOINT uvicorn main:app --reload --host 0.0.0.0 --port 1234

