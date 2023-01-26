FROM python:3.9.16-slim-bullseye
COPY req.txt . 
RUN pip install -r req.txt
WORKDIR /app
COPY . .

ENTRYPOINT python3 app.py