#!/bin/bash
set -e

# Map Cloudron addon variables to GlitchTip variables
export DATABASE_URL="${CLOUDRON_POSTGRESQL_URL}"
export REDIS_URL="${CLOUDRON_REDIS_URL}"

# Email Configuration
export EMAIL_HOST=${CLOUDRON_MAIL_SMTP_SERVER}
export EMAIL_PORT=${CLOUDRON_MAIL_SMTP_PORT}
export EMAIL_HOST_USER=${CLOUDRON_MAIL_SMTP_USERNAME}
export EMAIL_HOST_PASSWORD=${CLOUDRON_MAIL_SMTP_PASSWORD}
export EMAIL_USE_TLS=False
export DEFAULT_FROM_EMAIL=${CLOUDRON_MAIL_FROM}

# GlitchTip Configuration
# Ensure a secret key is available; Cloudron apps usually persist this in /app/data or use a fixed env var if safe
# We can use a hash of the dashboard domain or similar if not provided, but ideally we generated one.
# For now, we will generate one if not present, but it won't persist across restarts unless stored.
# Better to use CLOUDRON_APP_SECRET if available? GlitchTip *needs* this to be consistent for sessions.
# Cloudron doesn't provide CLOUDRON_APP_SECRET by default. 
# We should store it in /app/data/secret.key if it doesn't exist.

if [ ! -f /app/data/secret.key ]; then
    echo "Generating new secret key..."
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 50 > /app/data/secret.key
fi

export SECRET_KEY=$(cat /app/data/secret.key)

export GLITCHTIP_DOMAIN="https://${CLOUDRON_APP_DOMAIN}"
export PORT=8000
export ENABLE_USER_REGISTRATION=True
export ENABLE_ORGANIZATION_CREATION=True

# Run migrations
echo "Running migrations..."
# Assuming manage.py is in /code based on standard django/glitchtip images
cd /code
python manage.py migrate --noinput

# Collect static
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start Supervisor
echo "Starting Supervisor..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
