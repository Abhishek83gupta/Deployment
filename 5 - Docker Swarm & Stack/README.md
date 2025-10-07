# DevOps 3-Tier Application Deployment using Docker Swarm & Stack

![image](https://github.com/user-attachments/assets/210e00cc-c766-4b34-b205-895ac41d52b0)

![image](https://github.com/user-attachments/assets/01f5d705-6b19-40dc-bcc8-41b2476ec134)

![image](https://github.com/user-attachments/assets/2c714d9e-7c33-4b83-9a58-f0c26d5b0a82)

![image](https://github.com/user-attachments/assets/44384275-e03d-40b3-8863-573af1d70223)

![image](https://github.com/user-attachments/assets/fd33eb93-3c33-4149-93f2-ce44fa5b039f)

## Setup :- 
- Launch 3 EC2 Instances (All traffic, Anywhere):  
  1 = manager  
  2 = worker-1  
  3 = worker-2  

> Note: You can also edit Inbound/Outbound rules further to open specific ports.

- Connect your VM using any tools (e.g., MobaXterm)  
- Set Hostname (Optional)
  ```bash
  hostnamectl set-hostname manager/worker-1/worker-2
  ```
  
-  Initialize Docker Swarm on the manager node  
   ```bash
   docker swarm init
   ```
   
-  Join worker nodes to the swarm
   ```bash
   docker swarm join --token <worker_token> <manager_ip>:2377
   ```

 - Set Hostname (Optional)
   ```bash
   sudo -i
   hostnamectl set-hostname manager/worker-1/worker-2
   ```
  
 - Installation of Git & Docker:
   ```bash
   apt-get update -y
   
   apt-get install git -y
   git --version
   
   https://github.com/Abhishek83gupta/setups/blob/main/docker.sh
   docker --version
   ```
  
 - Clone the repository:
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
  vim Dockerfile
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
        VITE_API_URL = "http://localhost:3000"  --->  "http://any-node-ip-address:3000"  
 

## b) Setting up the Frontend

  1. Navigate to Backend Directory
  ```bash
   cd Frontend
  ```

  2. Creating Dockerfile
  ```bash
  vim Dockerfile
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
        CLIENT_URL = "http://localhost:5173"    --->  "http://any-node-ip-address"
        
 - We are using Nginx for frontend that why no port is required (default port 80)  

## c) Pushing frontend & backend Image to DockerHUB 

  1. Login to Docker HUB
  ```bash
   docker login
  ```

  2. Frontend 
  ```bash
  cd Frontend
  docker build -t frontend .
  docker tag frontend username/repo-name
  docker push username/repo-name
  ```
  
  3. Backend 
  ```bash
  cd Backend
  docker build -t backend .
  docker tag backend username/repo-name
  docker push username/repo-name
  ```
  
## d) Creating & Deploying docker-compose file using Stack (In root directory)

  1. Creating docker-compose.yml 
  ```bash
  vim docker-compose.yml
  ```
  
  2. Deploying docker-compose using Stack
  ```bash
  docker stack deploy -c docker-compose.yml mystack
  ```
  
## Trouble shooting :-

1. Pass frontend .env variables during image building bcz it will build and We are not able pass .env var from compose file
2. If CORS error coming then pass any node-ip, same for both frontend & backend (again push to docker HUB to use latest images)

## Service commands :- It's a way of exposing the application in docker-swarm.
| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker service create --name myweb --replicas 3 --publish/-p 80:80 nginx:alpine`| to create a service |
| `docker service ls   `  | to list services |
| `docker service ps myweb ` |  to list container of service |
| `docker service rm myweb ` | to remove the service |


| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker service scale myweb=10`| to scale the service |
| `docker service scale myweb=5`| to scale down |
| `docker service rollback myweb` | to go back to previous state |
| `docker service logs myweb ` | to check logs of service |
| `docker service inspect myweb` | display detail info about service |
- If you delete any running cont then it is going to create again (Self Healing : automatic recreates cont itself) 
  to check : docker rm id

## Cluster lvl commands :-
| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker swarm leave`| to start all services |
| `docker node rm id (master node)`  | to list services |
| `docker swarm join-token manager (master node) ` |  to list container of service |

 - we can't delete running worker node directly, we need to stop & then delete it.
 - to join the node on cluster use the previous token

## Stack commands :-
| Command                         | Description                      |
|---------------------------------|----------------------------------|
| `docker stack deploy -c docker-compose.yml mystack`| to deploy a stack |
| `docker stack ls`          | to list deployed/running stacks |
| `docker stack services mystack`| to list services in a stack |
| `docker stack ps mystack`      | to list container tasks in a stack |
| `docker stack rm mystack`  | to remove a stack
