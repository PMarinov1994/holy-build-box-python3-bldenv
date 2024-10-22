FROM pmarinov944/holy-build-box:4.0.1-amd64
ADD image/build_env.sh /build_env.sh

RUN bash /build_env.sh && rm -f /build_env.sh
