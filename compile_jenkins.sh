docker build -t jenkins:latest .
docker run -p 8080:8080 -p 50000:50000 jenkins:latest