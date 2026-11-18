bind = "0.0.0.0:8080"
worker_class = "gthread"
workers = 4
threads = 4
keepalive = 140

certfile = "/home/noted-flask/certs/server.crt"
keyfile = "/home/noted-flask/certs/server.key"

http_protocols = "h2, h1"
http2_max_concurrent_streams = 10
