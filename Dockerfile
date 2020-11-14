# [Choice] Python version: 3, 3.8, 3.7, 3.6
ARG VARIANT=3
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

# [Option] Install Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "source /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential dpkg-dev git libboost-all-dev libssl-dev \
    libpcap-dev libsqlite3-dev pkg-config python-minimal psmisc

RUN git clone --depth=1 --recursive --branch ndn-cxx-0.7.1 https://github.com/named-data/ndn-cxx.git && \
    cd ndn-cxx && \
    ./waf configure && \
    ./waf -j4 && \
    ./waf install && \
    ldconfig && \
    rm -rf ndn-cxx
RUN git clone --depth=1 --recursive --branch NFD-0.7.1 https://github.com/named-data/NFD.git && \
    cd NFD && \
    ./waf configure && \
    ./waf -j2 && \
    ./waf install && \
    cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf && \
    rm -rf NFD
RUN git clone --depth=1 --recursive --branch ndn-tools-0.7.1 https://github.com/named-data/ndn-tools.git && \
    cd ndn-tools && \
    ./waf configure && \
    ./waf -j2 && \
    ./waf install && \
    rm -rf ndn-tools
