# Use official Python image
FROM python:3.10-slim

# Set environment variables for Django
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8000
ENV DJANGO_SETTINGS_MODULE=myproject.settings.production  # Set to your production settings file

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the project
COPY . /app/

# Collect static files (so they are available for serving)
RUN python manage.py collectstatic --noinput

# Expose the application port
EXPOSE 8000

# Run the app using Gunicorn (instead of Django dev server)
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8000"]
