FROM node:20

  RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg imagemagick webp git python3 make g++ procps && apt-get clean && rm -rf /var/lib/apt/lists/*

  WORKDIR /app

  COPY package*.json ./

  # Step 1: Install all deps WITHOUT scripts (prevents libsignal native build failure)
  RUN npm install --legacy-peer-deps --ignore-scripts

  # Step 2: Force-compile better-sqlite3 from source (npm rebuild always runs the build, even if already installed)
  RUN npm rebuild better-sqlite3 --build-from-source

  # Step 3: Remove sharp installed without binary and reinstall it fresh with postinstall
  RUN rm -rf node_modules/sharp && \
      npm install --platform=linux --arch=x64 sharp@0.32.6 --legacy-peer-deps

  COPY . .

  EXPOSE 3000 5000

  ENV NODE_ENV=production

  CMD ["node", "index.js"]
  