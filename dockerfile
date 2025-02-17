FROM debian:stable

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    sudo \
    gdebi-core \
    r-base \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install RStudio Server
RUN wget https://download2.rstudio.org/server/debian12/x86_64/rstudio-server-2023.12.1-402-amd64.deb \
    && gdebi -n rstudio-server-2023.12.1-402-amd64.deb \
    && rm rstudio-server-2023.12.1-402-amd64.deb

# Create user 'readyplayer1' and add to sudo group
RUN useradd -m -s /bin/bash readyplayer1 && \
    echo 'readyplayer1:password' | chpasswd && \
    usermod -aG sudo readyplayer1

# Install Bioconductor base packages
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org/')" && \
    R -e "BiocManager::install(ask=FALSE)"

# Expose port for RStudio Server
EXPOSE 8787

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]
