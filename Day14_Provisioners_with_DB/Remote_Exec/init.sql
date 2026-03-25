-- Create a database
CREATE DATABASE IF NOT EXISTS mydb;

-- Use the database
USE mydb;

-- Create a table called 'users'
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

-- Insert some sample data (optional)
INSERT INTO users (name) VALUES ('Dhoni'), ('Sachin'), ('Sehwag');