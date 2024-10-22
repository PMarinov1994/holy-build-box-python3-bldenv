#!/bin/bash

# Build the image
docker build -t pmarinov944/holy-build-box-python3-bldenv:latest .

# Create version tag
docker tag pmarinov944/holy-build-box-python3-bldenv pmarinov944/holy-build-box-python3-bldenv:4.0.1-amd64

# Push to docker hub
docker push pmarinov944/holy-build-box-python3-bldenv:4.0.1-amd64
