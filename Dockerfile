# Use Python 3.10 as the base
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl jq fzf aria2 ffmpeg nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code (including your .sh script)
COPY . .

# Make the shell script executable
RUN chmod +x animepahe-dl.sh

# Inject Aria2 config for speed
RUN mkdir -p /root/.config/yt-dlp && \
    echo '--external-downloader aria2c\n--external-downloader-args "-x 16 -k 1M"\n--no-mtime\n--buffer-size 16M' > /root/.config/yt-dlp/config

# Start the bot
CMD ["python", "main.py"]
