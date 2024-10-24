FROM pmarinov944/holy-build-box-pyenv:1.0.0
ADD image /hbb_build
ARG DISABLE_OPTIMIZATIONS=0
RUN bash /hbb_build/build_python.sh
