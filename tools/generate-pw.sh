#!/bin/bash

# Generate a random password (16 characters) for the MariaDB root user
openssl rand -base64 16 > db_root_password

# Generate a random password (16 characters) for the MariaDB regular user
openssl rand -base64 16 > db_user_password

# Generate a random password (16 characters) for the Wordpress admin
openssl rand -base64 16 > wordpress_admin_password

# Generate a random password (16 characters) for the Wordpress user
openssl rand -base64 16 > wordpress_user_password
