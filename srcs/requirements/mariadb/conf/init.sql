CREATE DATABASE wordpress;
-- Creates a new user, wpuser, that can connect from any host (%)
CREATE USER 'wpuser'@'%' IDENTIFIED BY 'password';
-- Grants all privileges on all databases to the new user
GRANT ALL PRIVILEGES ON *.* TO 'wpuser'@'%' WITH GRANT OPTION;
-- Reloads the privileges from the grant tables to take effect immediately
FLUSH PRIVILEGES;
