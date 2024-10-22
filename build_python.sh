#!/bin/bash
docker run -t -i --rm -v $PWD/image/:/image pmarinov944/holy-build-box-python3-bldenv:latest bash /image/build_python.sh
