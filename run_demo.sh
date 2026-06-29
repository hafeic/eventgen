#!/bin/bash

# To avoid python environment issues, ensure you are in a python environment
# compatible with Eventgen (e.g. Python 3.7+), and dependencies are installed via `poetry install`.

echo "Creating the required log output directory..."
mkdir -p demo/logs

echo "Starting Eventgen with the demo configuration..."
poetry run splunk_eventgen generate demo/eventgen.conf
