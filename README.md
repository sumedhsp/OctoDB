# OctoDB: Scalable Multi-Tenant DBaaS with Automated Migrations

## Overview
**OctoDB** is a multi-tenant Database-as-a-Service (DBaaS) solution designed for modern cloud-based applications. It addresses challenges like dynamic tenant onboarding, schema migrations, and database security by combining scalability, flexibility, and automation.

## Key Features
- **Multi-Tenancy**: Tenant-specific schema customization with secure and isolated databases.
- **Automated Provisioning**: Serverless architecture for tenant onboarding and database setup.
- **Schema Migrations**: Automated, secure, and fault-tolerant migrations using Skeema and Redis-backed retry mechanisms.
- **Scalability**: Asynchronous workflows and load balancing for efficient resource utilization.
- **Security**: Advanced isolation, SQL injection prevention, and automatic rollback for failed migrations.
- **Logging & Monitoring**: Comprehensive logging with SQS and DynamoDB integration for auditability.

## System Components
- **Frontend**: Developed using Flask for tenant interactions.
- **Lambda Functions**: Automates database provisioning, schema migrations, logging, and CRUD operations.
- **Infrastructure as Code (IaC)**: Built with AWS services like EC2, S3, SSM, and CloudWatch.

## Workflow Highlights
### Dynamic Tenant Onboarding
- API Gateway validates user credentials and forwards requests to Lambda functions.
- Unique tenant and database IDs are generated.
- Databases are provisioned asynchronously with metadata stored in a centralized MetaDB.

### Schema Migrations
- Sanity checks and secure SQL validation ensure safety.
- Cascading schema updates maintain hierarchical consistency.
- Asynchronous execution with error recovery and user notification mechanisms.

### API Endpoints
- Centralized management of tenant metadata, logs, and database operations.
- Secure execution of SQL queries:
  - Supported: `SELECT`, `INSERT`, `UPDATE`, `DELETE`
  - Prohibited: `CREATE`, `DROP`, multi-statement queries
- Robust error handling with clear feedback for users.

### Logging
- Real-time log ingestion and storage using SQS and DynamoDB.
- Automated retry mechanisms for error recovery.
- Monitoring and debugging via CloudWatch.

## Architecture
OctoDB uses a hybrid architecture combining shared and isolated resources:
- **Database**: MySQL for scalability and schema management.
- **Automation**: AWS Lambda for serverless operations.
- **Caching**: Redis for retry mechanisms and query performance.
- **Storage**: DynamoDB for log and metadata management.

Here is an architecture diagram of the system:

![image](https://github.com/user-attachments/assets/2a55ebdb-09b0-48a1-8b27-33f9a0f708fa)


## Future Work
- **Selective Schema Updates**: Allow tenants to opt into updates from the parent schema.
- **Performance Optimization**: Adaptive caching, tenant-specific indexing, and smarter query handling.
- **Multi-Cloud Support**: Operate seamlessly across multiple cloud providers.
- **Enhanced Security**: AI-driven anomaly detection and advanced encryption.
- **Regulatory Compliance**: Automate data residency rules and compliance audits.
- **Offline Synchronization**: Enable database synchronization in unreliable internet conditions.

## Repository Structure
The repository is organized as follows:
```yaml
.
├── frontend:            # Frontend application built with Flask
│   ├── templates        # HTML templates for the web app
│   ├── app.py           # Main Flask application file
│   └── requirements.txt # Python dependencies for the Flask app
├── lambdafunctions:     # Lambda functions for automation and management
│   ├── LF0.py           # Handles api authentication for various endpoints in the system
│   ├── M0.py            # Responsible for performing sanity checks and invoking migrations asynchronously
│   ├── M1.py            # Handles the migration of the user database and logs details into the database. Also handles additional retry logic mechanisms, incase of failures and notifies the end-user of the status of migration
│   └── L1.py            # Handles the logging of necessary steps for audit purposes for individual user databases
│   └── LF2.py           # Responsible to display meta-data to the end-user for their respective database
│   └── LF4.py           # Handles the database CRUD operations
│   └── LF3.py           # Responsible for user creation and invoking of database creation asynchronously
│   └── LF6.py           # Handles the database creation
└── IaaC:                # Contains Infrastructure as a code for the whole system (created using Terraform)

---

For detailed documentation, feel free to explore the Project_Report and contact any members of the team.
