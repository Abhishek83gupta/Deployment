# Simple Nginx Test with Docker Compose

This guide provides a quick and simple test to run an Nginx web server using Docker Compose. It is an excellent way to verify that your Docker and Docker Compose installation is working correctly.

## Prerequisites

-   [Docker](https://docs.docker.com/get-docker/) installed.
-   [Docker Compose](https://docs.docker.com/compose/install/) installed.

---

## Instructions

### Step 1: Create Project Folder and `docker-compose.yml`

First, create a directory for this test project and navigate into it.

```bash
mkdir my-nginx-test
cd my-nginx-test
```

Next, create a file named `docker-compose.yml` and add the following content:

```yaml
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
```

-   **`image: nginx:alpine`**: This tells Docker Compose to use the lightweight `alpine` variant of the official Nginx image.
-   **`ports: - "8080:80"`**: This maps port `8080` on your host machine to port `80` inside the Nginx container.

### Step 2: Run the Container

From within the `my-nginx-test` directory, execute the following command to start the Nginx container in the background (`-d` flag for detached mode).

```bash
docker-compose up -d
```

This command will pull the `nginx:alpine` image if it's not already on your system and then create and start the container.

### Step 3: Test the Nginx Server

You can now verify that the server is running.

-   **Option 1: Use your web browser**
    Navigate to `http://localhost:8080`.

-   **Option 2: Use `curl` in your terminal**
    ```bash
    curl http://localhost:8080
    ```

Both methods should show you the default **"Welcome to nginx!"** page.

### Step 4: Stop and Remove the Container

When you are finished with the test, you can stop and remove the container and its associated network with a single command.

```bash
docker-compose down
```