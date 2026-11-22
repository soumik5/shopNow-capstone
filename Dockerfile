# Step 1: Use Node.js 20
FROM node:20-alpine

# Step 2: Set working directory
WORKDIR /app

# Step 3: Copy package files
COPY package*.json ./

# Step 4: Install dependencies
RUN npm ci

# Step 5: Copy backend source code
COPY . .

# Step 6: Expose backend port
EXPOSE 5000

# Step 7: Start backend application
CMD ["npm", "start"]


