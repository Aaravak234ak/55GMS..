FROM node:20

# Install curl and set npm to desired version via tarball
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -L https://registry.npmjs.org/npm/-/npm-11.9.0.tgz -o /tmp/npm.tgz \
    && npm install -g /tmp/npm.tgz \
    && npm -v

WORKDIR /usr/src/app

# Install dependencies (prefer ci when lockfile exists)
COPY package*.json ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --production; fi

# Copy app
COPY . .

EXPOSE 8080
ENV PORT 8080

CMD ["node", "."]
