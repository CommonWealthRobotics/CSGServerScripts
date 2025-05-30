FROM ubuntu:22.04

# Set environment variables
ENV ARCH=x86_64
ENV JVM=zulu17.50.19-ca-fx-jdk17.0.11-linux_x64
ENV JAVA_HOME=/root/bin/java17/

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create Java directory
RUN mkdir -p $JAVA_HOME

# Download BowlerStudio JAR
RUN mkdir /app/


# Set working directory
WORKDIR /app

# Create volume mount point for the File.txt
VOLUME ["/app/data"]

RUN apt-get update && apt-get install -y \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    xvfb  \
    ca-certificates \
    ca-certificates-java \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*
#Install the deps into the image
RUN bash launch.sh
    
COPY launch.sh /app/

CMD bash launch.sh /app/data/File.txt 3742
