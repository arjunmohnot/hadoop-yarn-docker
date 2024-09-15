# Use Ubuntu as the base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    ssh \
    rsync \
    curl \
    net-tools

# Add hadoop user
RUN useradd -m hadoop

# Set JAVA_HOME environment variable
# ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-arm64
ENV PATH=$PATH:$JAVA_HOME/bin

# Set Hadoop environment variables for YARN users
ENV YARN_RESOURCEMANAGER_USER=hadoop
ENV YARN_NODEMANAGER_USER=hadoop
ENV YARN_PROXYSERVER_USER=hadoop

# Copy Hadoop binaries from the host machine (the snapshot)
RUN rm -rf /usr/local; mkdir -p /usr/local
RUN rm -rf /usr/local/hadoop
COPY hadoop/SNAPSHOT/hadoop-*-SNAPSHOT.tar.gz /usr/local/hadoop.tar.gz
# Extract the binaries
RUN tar -xzf /usr/local/hadoop.tar.gz -C /usr/local/ && filename=$(ls /usr/local/ | grep -i hadoop | grep -i snapshot | head -n1) && ln -s "/usr/local/$filename" /usr/local/hadoop

# Set Hadoop environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Copy Hadoop configuration files
COPY hadoop/hadoop-conf/* $HADOOP_CONF_DIR/
RUN mkdir -p /usr/local/hadoop/logs && chown -R hadoop:hadoop /usr/local/hadoop*

# Format HDFS namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Expose ports for Hadoop services (UI, ResourceManager, NodeManagers)
EXPOSE 8088 8042 50070 50075

# Default command to keep the container running
CMD ["bash"]
