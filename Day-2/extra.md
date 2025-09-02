# 3-Tier Web Application Deployment using Docker on AWS EC2

This repository provides a step-by-step guide to deploying a full-stack 3-tier application on a single AWS EC2 instance. The application stack consists of:

-   **Frontend:** A React application built with Vite.
-   **Backend:** A Node.js and Express API.
-   **Database:** A MongoDB instance.

Each tier is containerized using Docker, and they communicate over a custom Docker network.

---

## Architecture Diagram

The application is deployed on a single EC2 instance, with each service running in its own Docker container.

```
+-----------------------------------------------------------------+
|   AWS EC2 Instance (Ubuntu)                                     |
|                                                                 |
|   +------------------ Docker Engine ------------------------+   |
|   |                                                         |   |
|   |   +-------------+      +-------------+      +---------+ |   |
|   |   |  Frontend   |----->|   Backend   |----->|  Mongo  | |   |
|   |   |  (React)    |      |  (Node.js)  |      |  (DB)   | |   |
|   |   | Port: 5173  |      | Port: 3000  |      | Port:   | |   |
|   |   +-------------+      +-------------+      | 27017   | |   |
|   |          ^                    ^             +---------+ |   |
|   |          |                    |                         |   |
|   |   +---------------------------------------------------+ |   |
|   |   |            Docker Network (3-tier-net)            | |   |
|   |   +---------------------------------------------------+ |   |
|   |                                                         |   |
|   +---------------------------------------------------------+   |
|                                                                 |
+-----------------------------------------------------------------+
      ^
      |
      | HTTP Traffic (Ports 5173, 3000)
      |
+------------------+
|   End User       |
| (Web Browser)    |
+------------------+
```

---

## Prerequisites

Before you begin, ensure you have the following:

-   An AWS account.
-   An AWS EC2 Key Pair (`.pem` file) to connect to your instance.
-   A terminal or SSH client (like MobaXterm, PuTTY, or your system's built-in terminal).
-   Basic knowledge of Linux commands, Docker, and AWS.

---

## Deployment Guide

Follow these steps to deploy the application.

### Step 1: Launch and Configure EC2 Instance

1.  **Launch an EC2 instance** from the AWS Console.
    -   **AMI:** Ubuntu Server 22.04 LTS (or newer).
    -   **Instance Type:** `t2.micro` (Free Tier eligible).
    -   **Key Pair:** Select your existing `.pem` key.
2.  **Configure Security Group:**
    Create a new security group and add the following **inbound rules**:
    | Type | Protocol | Port Range | Source | Description |
    | :--- | :--- | :--- | :--- | :--- |
    | SSH | TCP | 22 | My IP / Anywhere | For SSH access |
    | Custom TCP | TCP | 3000 | Anywhere (0.0.0.0/0) | Backend API |
    | Custom TCP | TCP | 5173 | Anywhere (0.0.0.0/0) | Frontend App |
3.  **Connect to your instance** using SSH:
    ```bash
    ssh -i "your-key.pem" ubuntu@<your-ec2-public-ip>
    ```

### Step 2: Prepare the Server

1.  **Switch to root user** and update the system:
    ```bash
    sudo -i
    apt update -y
    ```
2.  **Set a hostname** (optional but recommended):
    ```bash
    hostnamectl set-hostname 3-tier-app
    ```
3.  **Install Git and Docker:**
    ```bash
    apt install git -y
    apt install docker.io -y
    ```
4.  **Start and enable the Docker service:**
    ```bash
    systemctl start docker
    systemctl enable docker
    ```
5.  **Verify installations:**
    ```bash
    git --version
    docker --version
    ```

### Step 3: Clone the Repository

Clone the application source code onto your EC2 instance.
```bash
# Navigate to a suitable directory, e.g., /home/ubuntu
cd /home/ubuntu

git clone https://github.com/Abhishek83gupta/Pickest.git
cd Pickest
```

### Step 4: Configure Environment Variables

You must configure the application with your EC2 instance's public IP address.

**Note:** Find your Public IPv4 address from the EC2 dashboard.

1.  **Configure Backend:**
    Navigate to the `Backend` directory and create the `.env` file.
    ```bash
    cd Backend/
    vim .env
    ```
    Add the following content, replacing `<your-ec2-public-ip-address>` with your actual IP.
    ```dotenv
    PORT=3000
    DATABASE_URL=mongodb://mongo:27017/pickestDB
    CLIENT_URL=http://<your-ec2-public-ip-address>:5173
    ```

2.  **Configure Frontend:**
    Navigate to the `Frontend` directory and create the `.env.local` file.
    ```bash
    cd ../Frontend/
    cp .env.example .env.local
    vim .env.local
    ```
    Modify the `VITE_API_URL` variable:
    ```dotenv
    VITE_API_URL="http://<your-ec2-public-ip-address>:3000"
    ```
3.  **Return to the project root:**
    ```bash
    cd ..
    ```

### Step 5: Create Dockerfiles

Create a `Dockerfile` for both the backend and frontend services.

1.  **Backend Dockerfile:**
    Create `Backend/Dockerfile` with the following content:
    ```Dockerfile
    # Use an official Node.js runtime as a parent image
    FROM node:18-alpine

    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    EXPOSE 3000
    CMD ["npm", "start"]
    ```

2.  **Frontend Dockerfile:**
    Create `Frontend/Dockerfile` with the following content:
    ```Dockerfile
    # Use an official Node.js runtime as a parent image
    FROM node:18-alpine

    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    EXPOSE 5173
    # The --host flag is crucial to expose the app outside the container
    CMD ["npm", "run", "dev", "--", "--host"]
    ```

### Step 6: Build and Run the Containers

This section outlines how to run the application using individual Docker commands. For a simpler, recommended approach, see the **Docker Compose** section below.

1.  **Create a Docker Network:**
    This allows containers to communicate using their names.
    ```bash
    docker network create 3-tier-net
    ```

2.  **Build the Docker Images:**
    ```bash
    docker build -t backend-image ./Backend
    docker build -t frontend-image ./Frontend
    ```

3.  **Run the Containers:**
    Run the containers in order (Database -> Backend -> Frontend).
    ```bash
    # Run MongoDB Container
    docker run -d \
      -p 27017:27017 \
      --name mongo \
      --network 3-tier-net \
      mongo

    # Run Backend Container
    docker run -d \
      -p 3000:3000 \
      --name backend \
      --network 3-tier-net \
      backend-image

    # Run Frontend Container
    docker run -d \
      -p 5173:5173 \
      --name frontend \
      --network 3-tier-net \
      frontend-image
    ```

---

## Method 2: Using Docker Compose (Recommended)

Docker Compose simplifies the management of multi-container applications.

1.  **Install Docker Compose:**
    ```bash
    # Make sure you are root (sudo -i)
    apt install docker-compose -y
    ```
2.  **Create `docker-compose.yml` file:**
    In the root of the `Pickest` directory, create a `docker-compose.yml` file:
    ```bash
    vim docker-compose.yml
    ```
    Paste the following configuration:
    ```yaml
    version: '3.8'

    services:
      mongo:
        image: mongo
        container_name: mongo
        ports:
          - "27017:27017"
        volumes:
          - mongo-data:/data/db
        networks:
          - 3-tier-net

      backend:
        build: ./Backend
        container_name: backend
        ports:
          - "3000:3000"
        depends_on:
          - mongo
        environment:
          - DATABASE_URL=mongodb://mongo:27017/pickestDB
          # Remember to update the IP address here or use an env_file
          - CLIENT_URL=http://<your-ec2-public-ip-address>:5173
        networks:
          - 3-tier-net

      frontend:
        build: ./Frontend
        container_name: frontend
        ports:
          - "5173:5173"
        stdin_open: true # Required for Vite dev server
        tty: true
        depends_on:
          - backend
        # No environment variables needed here if you already created .env.local
        networks:
          - 3-tier-net

    networks:
      3-tier-net:
        driver: bridge

    volumes:
      mongo-data:
        driver: local
    ```
    > **Important:** Remember to replace `<your-ec2-public-ip-address>` in the `docker-compose.yml` file.

3.  **Build and Run with Docker Compose:**
    From the root of the `Pickest` directory, run:
    ```bash
    docker-compose up -d --build
    ```

---

## Verification

1.  **Check Running Containers:**
    ```bash
    docker ps
    # or with compose
    docker-compose ps
    ```
    You should see `frontend`, `backend`, and `mongo` containers running.

2.  **Access the Application:**
    -   **Backend API:** `http://<your-ec2-public-ip-address>:3000`
    -   **Frontend App:** `http://<your-ec2-public-ip-address>:5173`

---

## Troubleshooting

-   **Connection Refused:** Ensure the ports `3000` and `5173` are open in your EC2 instance's security group.
-   **CORS Error:** Double-check that `CLIENT_URL` in `Backend/.env` and `VITE_API_URL` in `Frontend/.env.local` are set correctly with your EC2 public IP.
-   **Container Exited:** Check the logs of the failed container for errors: `docker logs <container_name>`.
-   **Database Connection:** To test connectivity from the backend container:
    ```bash
    docker exec -it backend sh
    # Inside container, install mongo-tools (for alpine)
    apk add --no-cache mongodb-tools
    # Try connecting to mongo by its service name
    mongosh mongodb://mongo:27017
    ```

---

## Cleanup

To stop and remove the containers and avoid incurring AWS costs:

1.  **If using Docker Compose:**
    ```bash
    # In the directory with docker-compose.yml
    docker-compose down -v
    ```
    *(The `-v` flag removes the named volume `mongo-data`)*

2.  **If using manual Docker commands:**
    ```bash
    docker stop frontend backend mongo
    docker rm frontend backend mongo
    docker network rm 3-tier-net
    ```

3.  **Terminate the EC2 Instance:**
    Go to your AWS EC2 Dashboard, select the instance, and choose **Instance state -> Terminate instance**.