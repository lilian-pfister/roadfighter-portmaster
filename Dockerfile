FROM --platform=linux/arm64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y -qq \
      build-essential cmake git zip \
      libsdl1.2-compat-dev \
      libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

# Build
RUN cmake -B /build -DCMAKE_BUILD_TYPE=Release -DPORTMASTER=ON && \
    cmake --build /build -j$(nproc)

# Extract needed libs from apt packages into build dir
RUN mkdir -p /build/portmaster_libs && \
    for lib in \
        libSDL-1.2.so.0 \
        libSDL_image-1.2.so.0 \
        libSDL_mixer-1.2.so.0 \
        libSDL_ttf-2.0.so.0 \
        libbrotlicommon.so.1 \
        libdeflate.so.0 \
        libjbig.so.0 \
        libmad.so.0 \
        libmikmod.so.3 \
        libtiff.so.5 \
        libwebp.so.7; do \
        find /usr/lib -name "$lib" -exec cp -n {} /build/portmaster_libs/ \; 2>/dev/null || true; \
    done

# Package
RUN cpack --config /build/CPackConfig.cmake -B /build
