# DevOps 3-Tier Application Deployment using Docker Compose on AWS EC2

- Launch an EC2 Instance with (All traffic, Anywhere):
  Note : You can also edit Inbound/Outbound rules further to open specific port.

- Connect your VM using any tools (e.g Mobaxterm)


  1. Set up hostname:  
   ```bash
   sudo -i
   hostnamectl set-hostname tier-3-app
   apt-get update -y
   ```
  
  2. Installation of Git & Docker:
   ```bash
   apt-get install git -y
   apt-get install docker.io -y 
   git --version
   docker --version
   ```
  
  3. Clone the repository:
   ```bash
   git clone https://github.com/Abhishek83gupta/Pickest.git 
   cd Pickest
   ```


## a) Setting up the Backend 

  1. Navigate to Backend Directory
  ```bash
  cd Backend
  ```

  2. Creating Dockerfile
  ```bash
  vim Dokerfile
  ```
  
  3. Configure environment variables
  ```bash
  cp .env.example .env.local 
  ```
  OR
  
  ```bash
  vim .env.local 
  ```
  Note : Change .env.local variables
        VITE_API_URL = "http://localhost:3000"  --->  "http://ip-address:3000"  
 

## b) Setting up the Frontend

  1. Navigate to Backend Directory
  ```bash
   cd Frontend
  ```

  2. Creating Dockerfile
  ```bash
  vim Dokerfile
  ```
  
  3. Configure environment variables
  ```bash
  cp .env.example .env.local 
  ```
  OR
  
  ```bash
  vim .env.local 
  ```
  Note : Change .env.local variables
        CLIENT_URL = "http://localhost:5173"    --->  "http://ip-address:5173"

## b) Setting up docker-compose (In root directory)

  1. Creating docker-compose.yml
  ```bash
  vim docker-compose.yml
  ```

  2. To run docker-compose.yml
  ```bash
   # Start all services defined in docker-compose.yml in detached mode (runs containers in background)
   docker-compose up -d

   # Stop and remove all containers defined in docker-compose.yml
   docker-compose down

   # Rebuild images and start containers in detached mode
   docker-compose up -d --build

  ```

## Trouble shooting :-

1. If server get stuck on running compose commands then restart instance or you can use t2.medium as well


## Docker-compose commands :-

| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker-compose up -d`          | to start all services |
| `docker-compose up -d --build`  | -------- force fully building images again |
| `docker-compose down`           |  to stop all services |
| `docker-compose down --rmi/--remove all` | ------ and remove images too |

| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker-compose start`          | to start all services |
| `docker-compose stop`           | to stop ------------- |
| `docker-compose restart`        | to restart ----------- |
| `docker-compose start <id>`     | to start a specific service |
| `docker-compose stop <id>`      | to stop a --------------- |
| `docker-compose restart <id>`   | to restart a -------------- |
| `docker-compose pause <id>`     | Pause a specific service |
| `docker-compose unpause <id>`   | Unpause a paused service |

| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker-compose images`         | to get all image managed by compose file |
| `docker-compose ps -a`          | to get all container ------------------- |
| `docker-compose logs`           | to get all logs ------------------------ |
| `docker-compose logs <id>`      | to get logs for specific service |
| `docker-compose scale dth=10`  | to create 10 container of dth service
| `docker-compose top`            | to get all process managed by containers on compose file |
| `docker-compose -h`             | to get all commands of docker-compose |
