#################################################
#                   DATABASE                    #
#################################################
FROM ruby:2.7 as database

ARG DB_SIZE=100000
ARG EXPERIMENT_LABEL

WORKDIR /app
RUN mkdir bin db outputs resources result src
COPY resources/ /app/resources/
COPY src/ /app/src/
RUN ruby resources/create_database.rb $DB_SIZE

#################################################
#                     RUBY                      #
#################################################
FROM ruby:2.7 as ruby

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN sh resources/run.sh ruby src/ruby_a.rb ruby_a $ITERATIONS

#################################################
#                    PYTHON                     #
#################################################
FROM python:3.8 as python

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN sh resources/run.sh python3 src/python_a.py python_a $ITERATIONS

#################################################
#                      PHP                      #
#################################################
FROM php:7.4.9 as php

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN sh resources/run.sh php src/php_a.php php_a $ITERATIONS

#################################################
#                     NODE                      #
#################################################
FROM node:14 as node

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN sh resources/run.sh node src/node_a.js node_a $ITERATIONS

#################################################
#                       R                       #
#################################################
FROM r-base:4.0.2 as r-base

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN sh resources/run.sh Rscript src/r_a.r r_a $ITERATIONS

#################################################
#                     JAVA                      #
#################################################
FROM openjdk:16 as java

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN javac -d bin src/java_a.java
RUN cp src/java_a.java bin
RUN sh resources/run.sh cmd "java -cp bin java_a" java_a $ITERATIONS

#################################################
#                      GO                       #
#################################################
FROM golang:1.15 as go

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN go build -o bin/go_a src/go_a.go
RUN sh resources/run.sh cmd "bin/go_a" go_a $ITERATIONS
#################################################
#                    CRYSTAL                    #
#################################################
FROM crystallang/crystal:0.35.1 as crystal

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN crystal build -o bin/crystal_a src/crystal_a.cr
RUN sh resources/run.sh cmd "bin/crystal_a" crystal_a $ITERATIONS

#################################################
#                       C                       #
#################################################
FROM gcc:10.2.0 as gcc

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN gcc -o bin/c_a src/c_a.c
RUN sh resources/run.sh cmd "bin/c_a" c_a $ITERATIONS

#################################################
#                     COBOL                     #
#################################################
FROM hurriedreformist/gnucobol:3.1-builder as cobol

ARG ITERATIONS=100
WORKDIR /app
COPY --from=database /app /app

RUN cobc -x -o bin/cobol_a  src/cobol_a.cbl
RUN sh resources/run.sh cmd "bin/cobol_a" cobol_a $ITERATIONS

#################################################
#                   ANALYSIS                    #
#################################################
FROM nu12/rmarkdown:4.0.2 as report

ARG EXPERIMENT_LABEL

WORKDIR /app
COPY --from=database /app /app
COPY --from=ruby /app/outputs/*.csv /app/outputs
COPY --from=python /app/outputs/*.csv /app/outputs
COPY --from=php /app/outputs/*.csv /app/outputs
COPY --from=node /app/outputs/*.csv /app/outputs
COPY --from=r-base /app/outputs/*.csv /app/outputs
COPY --from=java /app/outputs/*.csv /app/outputs
COPY --from=go /app/outputs/*.csv /app/outputs
COPY --from=crystal /app/outputs/*.csv /app/outputs
COPY --from=gcc /app/outputs/*.csv /app/outputs
COPY --from=cobol /app/outputs/*.csv /app/outputs

RUN Rscript resources/result.r

RUN tar -czvf result/outputs.tar.gz /app/outputs/ /app/result/index.html

#################################################
#                    OUTPUT                     #
#################################################
FROM nginx:alpine as final

COPY --from=report /app/result/index.html /app/result/outputs.tar.gz /usr/share/nginx/html/