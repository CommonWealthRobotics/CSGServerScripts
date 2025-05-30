FROM ubuntu:22.04

# Set environment variables
ENV ARCH=x86_64
ENV JVM=zulu17.50.19-ca-fx-jdk17.0.11-linux_x64
ENV JAVA_HOME=/opt/java17/

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create Java directory
RUN mkdir -p $JAVA_HOME

# Download and install Java
RUN wget https://cdn.azul.com/zulu/bin/${JVM}.tar.gz && \
    tar -xvzf ${JVM}.tar.gz -C $JAVA_HOME && \
    mv $JAVA_HOME/$JVM/* $JAVA_HOME/ && \
    rm -rf $JAVA_HOME/$JVM && \
    rm ${JVM}.tar.gz

# Download BowlerStudio JAR
RUN mkdir /app/

RUN curl -L -o /app/BowlerStudio.jar https://github.com/CommonWealthRobotics/BowlerStudio/releases/latest/download/BowlerStudio.jar

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
    xvfb \
    && rm -rf /var/lib/apt/lists/*
# Set environment for headless operation
ENV DISPLAY=:99
# Set environment for JavaFX in headless mode
ENV JAVA_OPTS="-Dprism.order=sw \
    -Djava.awt.headless=false \
    -XX:MaxRAMPercentage=90.0 \
    -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2,TLSv1.3 \
    -Djdk.tls.client.protocols=TLSv1,TLSv1.1,TLSv1.2,TLSv1.3 \
    -Dcom.sun.net.ssl.checkRevocation=false \
    -Dtrust_all_cert=true \
    -Djsse.enableSNIExtension=false \
    -Djdk.tls.useExtendedMasterSecret=false \
    -Djavax.net.ssl.trustStoreType=JKS \
    -Dsun.security.ssl.allowUnsafeRenegotiation=true \
    -Dsun.security.ssl.allowLegacyHelloMessages=true \
    --add-exports javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
    --add-exports javafx.controls/com.sun.javafx.scene.control.behavior=ALL-UNNAMED \
    --add-exports javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED \
    --add-exports javafx.base/com.sun.javafx.event=ALL-UNNAMED \
    --add-exports javafx.controls/com.sun.javafx.scene.control.skin.resources=ALL-UNNAMED \
    --add-exports javafx.graphics/com.sun.javafx.util=ALL-UNNAMED \
    --add-exports javafx.graphics/com.sun.javafx.scene.input=ALL-UNNAMED \
    --add-opens javafx.graphics/javafx.scene=ALL-UNNAMED"
    
RUN apt-get update && apt-get install -y \
    ca-certificates \
    ca-certificates-java \
    && update-ca-certificates
# Run with virtual display
CMD ["xvfb-run", "-a", "-s", "-screen 0 1024x768x24", "bash", "-c", "$JAVA_HOME/bin/java $JAVA_OPTS -jar BowlerStudio.jar -csgserver /app/data/File.txt 3742"]
