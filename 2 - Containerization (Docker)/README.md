# DevOps 3-Tier Application Deployment using Docker Containers on AWS EC2

- Launch an EC2 Instance with (All traffic, Anywhere):
  Note : You can also edit Inbound/Outbound rules further to open specific port.

- Connect your VM using any tools (e.g Mobaxterm)


  1. Set up hostname:  
   ```bash
   sudo -i
   hostnamectl set-hostname tier-3-app
   apt update -y
   ```
  
  2. Installation of Git & Docker:
   ```bash
   apt install git -y
   apt install docker.io -y 
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
        VITE_API_URL = "http://localhost:3000"  --->  "http://<your ip-address>:3000"  
 
  4. Image creation
  ```bash
  docker build -t backend .

  #To check image
  docker images
  ```

  5. Container creation
  ```bash
  docker run -d -p 3000:3000 --name backend backend

  #To check container
  docker ps 

  #To check
  <your ip-address>:3000
  ```
  
## b) Setting up the Database (Inside the Backend folder)

  1. Getting the mongo image
  ```bash
  docker pull mongo
  
  #To check
  docker images 
  ```

  2. Creating Container
  ```bash
  docker run -d -p 27017:27017 --name mongo mongo

  #To check 
  docker ps 

  #To go inside container
  docker exec -it <id> bash/sh
   
  #To check DB is running
  mongosh

  #To exit
  exit
  ```


## c) Setting up the Frontend

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
        CLIENT_URL = "http://localhost:5173"    --->  "http://<your ip-address>:5173"
 
  4. Image creation 
  ```bash
  docker build -t frontend .

  #To check image
  docker images
  ```

  5. Container creation
  ```bash
  docker run -d -p 5173:5173 --name frontend frontend

  #To check container
  docker ps 

  #To check
  <your ip-address>:5173
  ```


## Trouble shooting :-

1. Inside docker check which type of OS is running Linux/Ubuntu accordingly use "docker exec -it <id> sh/bash"

2. If your backend not communicating with frontend (e.g CORS), then create network and pass as a flag during container creation 

3. If ip-address not working in browser, Try to to edit secruity group (Inbound rules) add port number accordingly

  ```bash
  # Create a new network
  docker network create mern-net

  # Stop and remove the old containers first
  docker stop backend frontend
  docker rm backend frontend

  # Re-create the containers on the new network
  docker run -d --name backend --network mern-net backend
  docker run -d --name frontend --network mern-net frontend
  ```
