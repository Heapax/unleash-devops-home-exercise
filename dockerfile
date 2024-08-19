# Stage 1: Build
FROM node:20-slim AS build

# Create a non-root user for building the application
RUN useradd -ms /bin/sh appuser
USER appuser

# Set the working directory
WORKDIR /home/appuser/app

# Copy dependency manifests and install dependencies
COPY --chown=appuser:appuser package*.json ./
RUN npm install

# Copy the application code and build
COPY --chown=appuser:appuser . .
RUN npm run build



# Stage 2: Production
FROM node:20-slim

# Create a non-root user for running the application
RUN useradd -ms /bin/sh appuser
USER appuser

# Set the working directory
WORKDIR /home/appuser/app

# Copy only necessary files from the build stage
COPY --from=build /home/appuser/app/dist ./dist
COPY --from=build /home/appuser/app/package*.json ./

# Install only production dependencies
RUN npm install --production

# Expose the application port
EXPOSE 3000

# Run the application
CMD ["node", "dist/index.js"]
