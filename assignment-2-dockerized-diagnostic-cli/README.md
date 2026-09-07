# Assignment 2 – Dockerized Diagnostic CLI

## Description

This project is a Bash-based Linux diagnostic tool packaged as a Docker application. It provides commands for displaying system information, checking network connectivity, displaying disk information, and showing command usage.

The application is containerized using Docker and can also be run with Docker Compose.

## Project Structure


.
├── app/
│   ├── diagnostic.sh
│   └── health-check.sh
├── Dockerfile
├── compose.yaml
├── .dockerignore
├── test.sh
├── grade.sh
└── README.md

## Requirements

* Linux environment
* Docker
* Docker Compose

## Build the Docker Image

Build the application image:

docker build -t diagnostic-tool .


## Usage

### Display help

docker run --rm diagnostic-tool help

### Display system information


docker run --rm diagnostic-tool system


### Check disk information


docker run --rm diagnostic-tool disk

### Check network connectivity


docker run --rm diagnostic-tool network google.com


## Invalid Commands

Invalid commands return exit code `2`.

Example:


docker run --rm diagnostic-tool invalid
echo $?


Expected output:

2

The application uses the following exit codes:

* `0` – Success
* `1` – Operational or runtime failure
* `2` – Invalid command or input

## Docker Compose

Build the application:


docker compose build

Run the application:


docker compose run --rm diagnostic help


Other commands can also be passed through Docker Compose:

docker compose run --rm diagnostic system
docker compose run --rm diagnostic disk
docker compose run --rm diagnostic network google.com

## Testing

Run the test suite:


chmod +x test.sh
./test.sh


The test suite checks:

* Help command
* System command
* Disk command
* Invalid command handling

## Health Check

The health check script verifies that the main diagnostic application exists, is executable, and can successfully run the help command.

It can be tested inside the Docker image with:


docker run --rm --entrypoint /app/health-check.sh diagnostic-tool

## Assumptions

* The application is run in a Linux environment or inside the provided Linux Docker container.
* Network connectivity depends on the Docker container having network access.
* Some commands depend on utilities installed in the Alpine Linux image.
* The Docker image is built locally using the provided Dockerfile.
