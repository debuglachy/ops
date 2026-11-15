FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir --upgrade --force-reinstall -r requirements.txt

COPY . .

ENV NOTED_APP_PORT=8080

#change app.py, .env and ENV fallback values before changing EXPOSE value
EXPOSE 8080

CMD python app.py
