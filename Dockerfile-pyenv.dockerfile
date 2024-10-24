FROM pmarinov944/holy-build-box:4.0.1
ADD image /hbb_build
ARG DISABLE_OPTIMIZATIONS=0
RUN bash /hbb_build/build_env.sh
