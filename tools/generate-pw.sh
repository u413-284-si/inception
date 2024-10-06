#!/bin/bash

# Generate a random password (16 characters) for the MariaDB root user
openssl rand -base64 16 > db_root_password

# Generate a random password (16 characters) for the MariaDB regular user
openssl rand -base64 16 > db_user_password
