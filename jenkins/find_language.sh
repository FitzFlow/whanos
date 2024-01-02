#!/bin/bash
#cd "$WORKSPACE"

BASE_DIR="INSERT_YOUR_PATH_HERE"

for filename in *; do
  if [ -f "$filename" ]; then
    case "$filename" in
      Makefile)
        echo "Makefile found. Compiling C code in $PWD"
        echo "je vais build"

        if [ -f "Dockerfile.base" ]; then
          docker build -t whanos-c -f "${BASE_DIR}/images/c/Dockerfile.base" .
          echo "c'est build base"
        else
          docker build -t whanos-c -f "${BASE_DIR}/images/c/Dockerfile.standalone" .
          docker tag whanos-c localhost:5001/whanos-c
          docker push localhost:5001/whanos-c
          docker pull localhost:5001/whanos-c
          docker rmi whanos-c
          echo "c'est build standalone"
        fi

        echo "c'est build"
        ;;
      package.json)
        echo "package.json found. Building JavaScript project in $PWD"
        npm install
        if [ -f "Dockerfile.base" ]; then
          docker build -t whanos-c -f "${BASE_DIR}/images/javascript/Dockerfile.base" .
          echo "c'est build base"
        else
          docker build -t whanos-javascript -f "${BASE_DIR}/images/javascript/Dockerfile.standalone" .
          docker tag whanos-javascript localhost:5001/whanos-javascript
          docker push localhost:5001/whanos-javascript
          docker pull localhost:5001/whanos-javascript
          docker rmi whanos-javascript
          echo "c'est build javascript"
        fi
        ;;
      requirements.txt)
        echo "requirements.txt found. Installing Python dependencies in $PWD"
        pip3 install -r requirements.txt

        if [ -f "Dockerfile.base" ]; then
          docker build -t whanos-c -f "${BASE_DIR}/images/python/Dockerfile.base" .
          echo "c'est build base"
        else
          docker build -t whanos-python -f "${BASE_DIR}/images/python/Dockerfile.standalone" .
          docker tag whanos-python localhost:5001/whanos-python
          docker push localhost:5001/whanos-python
          docker pull localhost:5001/whanos-python
          docker rmi whanos-python
          echo "c'est build python"
        fi
        ;;
    esac
  fi
done

cd app
for filename in *; do
  if [ -f "$filename" ]; then
    case "$filename" in
      pom.xml)
        echo "pom.xml found. Building Java project in $PWD"
        mvn package
        if [ -f "Dockerfile.base" ]; then
          docker build -t whanos-c -f "${BASE_DIR}/images/java/Dockerfile.base" .
          echo "c'est build base"
        else
          docker build -t whanos-java -f "${BASE_DIR}/images/java/Dockerfile.standalone" .
          docker tag whanos-java localhost:5001/whanos-java
          docker push localhost:5001/whanos-java
          docker pull localhost:5001/whanos-java
          docker rmi whanos-java
          echo "c'est build java"
        fi
        ;;
      main.bf)
        echo "main.bf found in 'app' subdirectory. Running Befunge code in $PWD/app"
        befunge-93 "main.bf"
        if [ -f "Dockerfile.base" ]; then
          docker build -t whanos-c -f "${BASE_DIR}/images/befunge/Dockerfile.base" .
          echo "c'est build base"
        else
          docker build -t whanos-befunge -f "${BASE_DIR}/images/befunge/Dockerfile.standalone" .
          docker tag whanos-befunge localhost:5001/whanos-befunge
          docker push localhost:5001/whanos-befunge
          docker pull localhost:5001/whanos-befunge
          docker rmi whanos-befunge
          echo "c'est build befunge"
        fi
        ;;
    esac
  fi
done