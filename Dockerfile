# Use official Python image
FROM python:3.11-slim

# Set work directory
WORKDIR /app

# Copy requirements.txt first to leverage caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY . .

# Command to run the app
CMD ["python", "app.py"]
