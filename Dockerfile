FROM node:24-bookworm-slim

# Install socat and net-tools for proxy and debugging
RUN apt-get update && apt-get install -y socat net-tools && rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw

# Set working directory
WORKDIR /app

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Default port
ENV PORT=8080

EXPOSE 8080

CMD ["/app/start.sh"]
