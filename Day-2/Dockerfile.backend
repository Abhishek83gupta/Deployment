# Use an official lightweight Node.js image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy all files from the project root to the container
COPY . .

# Install all dependencies
RUN npm install

# Copy environment-specific config file
# This step is optional — you can also pass environment variables at runtime instead
COPY .env.local .env

# Expose port 3000 to the host (React dev server or production app)
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]