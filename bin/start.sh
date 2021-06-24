#!/usr/bin/env bash

while ! pg_isready -q -h postgres-service -p 5432 -U $POSTGRES_USER
do
  echo "$(date) Waiting POSTGRES to start"
  sleep 2
done

sleep 5

echo "Beginning migration script..."
/app/bin/hvac_umbrella eval "HVACDatabase.Release.migrate()"

echo "Starting app..."
/app/bin/hvac_umbrella start
