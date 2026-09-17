FROM python:3.10-slim

# Set environment variables to prevent Python from writing .pyc files
# and to buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/ ./src/

# Define default command to run the ingestion script
CMD ["python", "src/extract.py"]
