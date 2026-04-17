#!/usr/bin/env bash
# Pre-validate the environment and export engine-specific connection vars.

# DB_TYPE
if [ "${DB_TYPE}" != "postgresql" ] && [ "${DB_TYPE}" != "mongodb" ]; then
  echo "DB_TYPE must be set to 'postgresql' or 'mongodb'."
  exit 1
fi

# Required common vars
if [ "${DB_NAME}" = "**None**" ] && [ "${DB_NAME_FILE}" = "**None**" ]; then
  echo "You need to set the DB_NAME or DB_NAME_FILE environment variable."
  exit 1
fi

if [ "${DB_HOST}" = "**None**" ]; then
  echo "You need to set the DB_HOST environment variable."
  exit 1
fi

if [ "${DB_USER}" = "**None**" ] && [ "${DB_USER_FILE}" = "**None**" ]; then
  echo "You need to set the DB_USER or DB_USER_FILE environment variable."
  exit 1
fi

# Engine-specific password requirements
case "${DB_TYPE}" in
  postgresql)
    if [ "${DB_PASS}" = "**None**" ] && [ "${DB_PASS_FILE}" = "**None**" ] && [ "${DB_PASSFILE_STORE}" = "**None**" ]; then
      echo "You need to set DB_PASS, DB_PASS_FILE, or DB_PASSFILE_STORE (postgresql)."
      exit 1
    fi
    ;;
  mongodb)
    if [ "${DB_PASS}" = "**None**" ] && [ "${DB_PASS_FILE}" = "**None**" ]; then
      echo "You need to set DB_PASS or DB_PASS_FILE (mongodb)."
      exit 1
    fi
    ;;
esac

# Misuse warnings (engine-specific vars set for wrong engine)
if [ "${DB_TYPE}" = "mongodb" ] && [ "${DB_CLUSTER}" = "TRUE" ]; then
  echo "Warning: DB_CLUSTER is postgresql-only; ignoring."
fi
if [ "${DB_TYPE}" = "mongodb" ] && [ "${DB_PASSFILE_STORE}" != "**None**" ]; then
  echo "Warning: DB_PASSFILE_STORE is postgresql-only; ignoring."
fi
if [ "${DB_TYPE}" = "postgresql" ] && [ "${DB_AUTH}" != "**None**" ]; then
  echo "Warning: DB_AUTH is mongodb-only; ignoring."
fi

# Resolve DB_NAMES
if [ "${DB_NAME_FILE}" = "**None**" ]; then
  DB_NAMES=$(echo "${DB_NAME}" | tr , " ")
elif [ -r "${DB_NAME_FILE}" ]; then
  DB_NAMES=$(cat "${DB_NAME_FILE}")
else
  echo "Missing DB_NAME_FILE file."
  exit 1
fi

# Resolve user
if [ "${DB_USER_FILE}" = "**None**" ]; then
  DB_USER_RESOLVED="${DB_USER}"
elif [ -r "${DB_USER_FILE}" ]; then
  DB_USER_RESOLVED=$(cat "${DB_USER_FILE}")
else
  echo "Missing DB_USER_FILE file."
  exit 1
fi

# Resolve password (DB_PASS_FILE > DB_PASS; DB_PASSFILE_STORE handled per-engine)
DB_PASS_RESOLVED=""
if [ "${DB_PASS_FILE}" != "**None**" ]; then
  if [ -r "${DB_PASS_FILE}" ]; then
    DB_PASS_RESOLVED=$(cat "${DB_PASS_FILE}")
  else
    echo "Missing DB_PASS_FILE file."
    exit 1
  fi
elif [ "${DB_PASS}" != "**None**" ]; then
  DB_PASS_RESOLVED="${DB_PASS}"
fi

# Port default
if [ "${DB_PORT}" = "**None**" ] || [ -z "${DB_PORT}" ]; then
  case "${DB_TYPE}" in
    postgresql) DB_PORT=5432 ;;
    mongodb)    DB_PORT=27017 ;;
  esac
fi

# Engine-specific connection setup
case "${DB_TYPE}" in
  postgresql)
    export PGUSER="${DB_USER_RESOLVED}"
    export PGHOST="${DB_HOST}"
    export PGPORT="${DB_PORT}"
    if [ "${DB_PASSFILE_STORE}" != "**None**" ]; then
      if [ -r "${DB_PASSFILE_STORE}" ]; then
        export PGPASSFILE="${DB_PASSFILE_STORE}"
      else
        echo "Missing DB_PASSFILE_STORE file."
        exit 1
      fi
    else
      export PGPASSWORD="${DB_PASS_RESOLVED}"
    fi
    ;;
  mongodb)
    MONGO_AUTH_DB="${DB_AUTH}"
    if [ "${MONGO_AUTH_DB}" = "**None**" ] || [ -z "${MONGO_AUTH_DB}" ]; then
      MONGO_AUTH_DB="admin"
    fi
    export MONGO_URI="mongodb://${DB_USER_RESOLVED}:${DB_PASS_RESOLVED}@${DB_HOST}:${DB_PORT}/?authSource=${MONGO_AUTH_DB}"
    ;;
esac

export DB_NAMES

# Retention windows
KEEP_MINS=${BACKUP_KEEP_MINS}
KEEP_DAYS=${BACKUP_KEEP_DAYS}
KEEP_WEEKS=$(( (BACKUP_KEEP_WEEKS * 7) + 1 ))
KEEP_MONTHS=$(( (BACKUP_KEEP_MONTHS * 31) + 1 ))

# Validate backup dir
if [ ! -d "${BACKUP_DIR}" ] || [ ! -w "${BACKUP_DIR}" ] || [ ! -x "${BACKUP_DIR}" ]; then
  echo "BACKUP_DIR points to a file or folder with insufficient permissions."
  exit 1
fi
