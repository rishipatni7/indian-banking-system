# Indian Banking Management System

<div align="center">
  <img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white" alt="Java"/>
  <img src="https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL"/>
  <img src="https://img.shields.io/badge/Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black" alt="Tomcat"/>
</div>

<br />

A robust, enterprise-grade banking application designed to simulate core Indian banking operations. This system provides a comprehensive platform for both banking administrators and customers, prioritizing secure transactions and seamless account management.

## 🌟 Key Features

### For Customers
- **Secure Authentication & Onboarding**: Simplified registration and secure login mechanisms.
- **Account Dashboard**: Real-time overview of current balances and account details.
- **ACID-Compliant Transfers**: Bulletproof money transfer system ensuring funds are consistently updated across accounts without data anomalies.
- **Transaction History**: Comprehensive ledger tracking incoming and outgoing funds.

### For Administrators
- **Account Verification**: Robust vetting process for reviewing and approving new customer accounts.
- **Role-Based Access Control**: Strict segregation between admin privileges and standard customer actions.
- **Account Management**: Active monitoring and maintenance of global account lifecycles.

## 🛠️ Technology Stack

- **Backend Logic**: Java (Servlets, JSP)
- **Database Architecture**: MySQL
- **Web Server**: Apache Tomcat
- **Frontend Layer**: HTML5, CSS3 

## ⚙️ Architecture Highlights

This project utilizes the **MVC (Model-View-Controller)** pattern to separate business logic from the presentation layer:
- **Controllers** (e.g., `TransferServlet`, `LoginServlet`) handle the routing logic.
- **Models** abstract the database interactions with strict SQL integrity.
- **Views** leverage JSP to hydrate dynamic frontend data securely.

## 🔐 Security & Database Integrity

Special attention was given to the money-transfer pipeline (`TransferServlet.java`), enforcing database **ACID properties (Atomicity, Consistency, Isolation, Durability)**. If a transfer fails mid-transaction or an account doesn't exist, the state rolls back, completely eliminating the possibility of lost funds or skewed balances.

---
*Created as a comprehensive demonstration of enterprise Java web development concepts.*
