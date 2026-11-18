FROM python:3.12-slim

RUN useradd --create-home noted-flask
WORKDIR /home/noted-flask


COPY setupfiles/requirements.txt .
RUN python3 -m pip install --no-cache-dir --upgrade --force-reinstall -r requirements.txt


COPY --chown=noted-flask:noted-flask . .
RUN python3 -m pip install /home/noted-flask
ENV NOTED_APP_PORT=8080

#change app.py, .env and ENV fallback values before changing EXPOSE value
EXPOSE 8080

CMD ["python3", "-m", "gunicorn", "app:app", "--workers", "4", "--config", "/home/noted-flask/setupfiles/gunicorn.conf.py", "--user", "noted-flask"]
