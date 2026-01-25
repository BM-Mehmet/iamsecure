FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    iptables \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create restricted user for sandboxing
RUN groupadd -g 2000 appuser && \
    useradd -u 2000 -g 2000 -s /bin/false appuser

# Copy local Portspoof directory to container
COPY Portspoof /opt/portspoof

# Build Portspoof
WORKDIR /opt/portspoof
RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_SYSCONFDIR=/etc .. && \
    make && \
    make install

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Expose the default Portspoof port (though iptables will redirect everything)
EXPOSE 4444

ENTRYPOINT ["/entrypoint.sh"]
