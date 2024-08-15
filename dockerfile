# Use the offical Node.js image as a base image
FROM node:20

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the application code
COPY . .

# Compile TypeScript to JavaScript
RUN npm run build

# Expose the application port
EXPOSE 3000

# Run the application
CMD ["node", "dist/index.js"]