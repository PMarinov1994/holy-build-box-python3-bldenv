#!/bin/bash
docker run -t -i --rm -v $PWD/image/:/image pmarinov944/holy-build-box-python3-bldenv:4.0.1-amd64 bash /image/build_python.sh
