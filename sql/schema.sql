CREATE DATABASE IF NOT EXISTS indian_bank;
USE indian_bank;

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    balance DECIMAL(15, 2) DEFAULT 0.00 CHECK (balance >= 0),
    kyc_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE kyc_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    document_reference VARCHAR(255) NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account INT,
    to_account INT,
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
    transaction_type ENUM('IMPS', 'NEFT') NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_account) REFERENCES accounts(account_id) ON DELETE SET NULL,
    FOREIGN KEY (to_account) REFERENCES accounts(account_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE account_applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    account_type ENUM('SAVINGS', 'CHECKING', 'JOINT') NOT NULL,
    currency ENUM('INR', 'USD', 'EUR') DEFAULT 'INR',
    initial_deposit DECIMAL(15, 2) NOT NULL,
    id_type VARCHAR(50) NOT NULL,
    id_number VARCHAR(100) NOT NULL,
    occupation VARCHAR(100),
    employer_name VARCHAR(150),
    
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE service_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    request_type ENUM('DEPOSIT', 'DEBIT_CARD', 'CREDIT_CARD') NOT NULL,
    amount DECIMAL(15, 2),
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Insert a default Administrator account
INSERT INTO accounts (username, password_hash, full_name, role, balance, kyc_status) 
VALUES ('admin', 'admin123', 'System Administrator', 'ADMIN', 0.00, 'APPROVED');
