# Multi-stage Dockerfile for Auggie CLI in a distroless container
# Stage 1: Build stage - Install Auggie CLI using Node.js
FROM node:22-slim AS builder

# Install auggie CLI globally
RUN npm install -g @augmentcode/auggie

# Find where auggie is installed and verify it works
RUN which auggie && auggie --version

# Stage 2: Runtime stage - Distroless container
# Using debian12 (bookworm) based distroless with nodejs support
FROM gcr.io/distroless/nodejs22-debian12

# Copy the globally installed npm packages from the builder stage
# npm global packages are installed to /usr/local/lib/node_modules
COPY --from=builder /usr/local/lib/node_modules/@augmentcode /usr/local/lib/node_modules/@augmentcode

# Set working directory
WORKDIR /workspace

# Set the entrypoint to run auggie via node
# The distroless nodejs image runs node as the entrypoint
ENTRYPOINT ["/nodejs/bin/node", "/usr/local/lib/node_modules/@augmentcode/auggie/augment.mjs"]



