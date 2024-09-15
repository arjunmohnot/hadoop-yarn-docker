# Hadoop YARN Docker
Repository for provisioning a YARN ResourceManager cluster on Docker for quick validation and testing. This setup allows you to easily run and manage a YARN cluster in a containerized environment, perfect for development, troubleshooting, and rapid experimentation with Apache Hadoop.

## Prerequisites
- **Docker**: Ensure Docker is installed and running on your machine.
- **Docker Compose**: Install Docker Compose for orchestrating multi-container applications.
- **Maven**: Required for building Hadoop from source.
- **Hadoop Source Code**: Clone the latest version of Hadoop from the official repository.

## Setup Instructions

### 1. Clone the Hadoop Repository
First, clone the latest version of Hadoop using Git:

```bash
git clone https://gitbox.apache.org/repos/asf/hadoop.git
```

### 2. Build Hadoop from Source
After making any necessary changes or if you just need to build Hadoop, navigate to the Hadoop root directory and run the following Maven command to build the distribution package:
```bash
mvn clean package -Pdist -DskipTests -Dtar
```

This will create a Hadoop distribution package without running tests, which can then be used to set up your Docker containers.

### 3. Move the Hadoop Distribution to Docker Setup
Once the build is complete, copy the generated Hadoop distribution snapshot to the `hadoop/SNAPSHOT` directory in this repository:
```bash
cp <your-hadoop-repo>/hadoop-dist/target/hadoop-<version>-SNAPSHOT.tar.gz hadoop-yarn-docker/hadoop/SNAPSHOT/
```
Replace `<your-hadoop-repo>` with the path where hadoop repo is cloned, and `<version>` with the correct version number of Hadoop you built.

### 4. Build the Docker Images
To build the required Docker images for ResourceManager and NodeManager, run the following command from the root of the `hadoop-yarn-docker` repository:
```bash
docker-compose build
```

### 5. Start the YARN Cluster
After the images are built, bring up the necessary services (ResourceManager and NodeManager) using Docker Compose:
```bash
docker-compose up -d
```
This will start the YARN ResourceManager and NodeManager services in the background. You can check the status of your containers with:
```bash
docker-compose ps
```

### 6. Start the YARN Cluster
You can now interact with the YARN ResourceManager via the web interface (typically available at `http://localhost:8088`) or using the YARN CLI commands within the container (`docker exec -it resourcemanager /bin/bash`). Note: Hadoop path: `/usr/local/hadoop` for looking at the logs, configured bin and confs.

### 7. Stopping the Cluster
To stop the cluster and remove the containers, run:
```bash
docker-compose down
```
This will stop and clean up all the services associated with the YARN cluster.

## Notes
- This setup is designed for testing and validation purposes in a containerized environment. 
- For production use, consider running Hadoop in a distributed mode.
- Modify the `docker-compose.yml` file to adjust memory and CPU resources based on your environment.
- Ensure your Docker daemon has sufficient resources allocated (memory/CPU) for running both ResourceManager and NodeManager containers.

## Troubleshooting
- **Build Issues**: If the build fails, ensure that all dependencies (Maven, JDK) are correctly installed and that you're using compatible versions.
- **Docker Issues**: If Docker services fail to start, verify that Docker and Docker Compose are installed and running properly.

## License
This project is licensed under the [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0).
