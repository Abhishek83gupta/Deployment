# DevOps 3-Tier Project Deployment | Virtualisation on AWS EC2

- Launch an EC2 Instance with (All traffic, Anywhere):
   
- Connect your VM using any tools (e.g Mobaxterm)


  1. Set up hostname:  
   ```bash
   sudo -i
   hostnamectl set-hostname tier-3-app
   apt update -y
   ```
  
  2. Installation of Git:
   ```bash
   apt install git -y
   git --version
   ```
  
  3. Clone the repository:
   ```bash
   git clone https://github.com/Abhishek83gupta/Pickest.git 
   cd Pickest
   ```

  4. Set up environment:
   ```bash
   # Installation Node.js from below Link
   https://nodejs.org/en/download
   
   nvm -v
   node -v
   npm -v

   # Installation Mongodb from below Link
   https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian

   sudo apt-get install gnupg curl

   curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor

   echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

   sudo apt-get update
   sudo apt-get install -y mongodb-org 

   sudo systemctl start mongod
   sudo systemctl enable mongod
   sudo systemctl status mongod
   sudo systemctl stop mongod
   sudo systemctl restart mongod

   mongosh 
   ```

  5. Installation of pm2 
   ```bash
   sudo npm install pm2 -g
   pm2 -v
   ```


Setting up the Backend 

  1. Navigate to Backend Directory
  ```bash
  cd Backend
  ```

  2. Install required Dependencies
  ```bash
  npm i
  ```
  
  3. Configure environment variables
  ```bash
  cp .env.example .env.local
  ```
 
  4. Start Backend 
  ```bash
  npm run start

  #Using pm2
  pm2 start --name backend "npm run start"
  
  #To check
  <your ip-address>:3000
  ```





Setting up the Frontend

  1. Navigate to Backend Directory
  ```bash
   cd Frontend
  ```

  2. Install required Dependencies
  ```bash
  npm i
  ```
  
  3. Configure environment variables
  ```bash
  cp .env.example .env.local
  ```
 
  4. Start Frontend 
  ```bash
  npm run dev -- --host

  #Using pm2
  pm2 start --name frontend "npm run dev -- --host"
  
  #To check
  <your ip-address>:5173
  ```


Note : After all Done make change in both Frontend and Backend env variables

VITE_API_URL = "http://localhost:3000"  --->  "http://<your ip-address>:3000"
```bash
pm2 restart frontend
```
CLIENT_URL = "http://localhost:5173"    --->  "http://<your ip-address>:5173"
```bash
pm2 restart backend
```
