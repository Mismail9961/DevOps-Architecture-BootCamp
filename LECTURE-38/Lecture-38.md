# Lecture 38: Databases and Their Types

## 1. What Is a Database?

A **database** is an organized, electronic collection of data.

### Before: Physical Files
- Only one copy of each file
- Slow updates across branches
- Hard to search
- Easy to lose, no reliable backups

### Now: Electronic Databases
- Central storage with **real-time updates**
- No duplicate data
- Easy to search and link related data
- Many users can work together
- Reliable backups

## 2. Relational Databases (SQL)

Data is stored in **tables** made of **rows** (records) and **columns** (attributes).

- Has a fixed **schema**: a blueprint that defines columns, data types and constraints.
- Tables are linked using **keys**:
  - **Primary key:** uniquely identifies a row
  - **Foreign key:** points to a row in another table
- Example: a `students` table linked to a `courses` table.
- Strong **data consistency and integrity**.

**Examples:** MySQL, PostgreSQL, Oracle DB, Microsoft SQL Server
**Used in:** banking, HR systems, ERP

## 3. NoSQL Databases ("Not Only SQL")

- **Flexible or no fixed schema**
- Good for unstructured or semi-structured data and large distributed systems
- Faster to develop and scale, but may give up some strict integrity

### Main NoSQL Models

| Model | How it stores data | Examples | Use cases |
|---|---|---|---|
| **Document** | JSON-like documents | MongoDB, Firestore | Blogs, CMS, user profiles |
| **Key-Value** | Key and value pairs | DynamoDB, Redis | Sessions, caching, shopping carts |

## 4. Graph Databases

- Data stored as **nodes** (entities) connected by **edges** (relationships).
- Relationships are stored directly, so traversing them is fast.

**Examples:** Neo4j, Amazon Neptune
**Used in:** social networks, recommendation engines, fraud detection

## 5. Time-Series Databases

- Store data **with timestamps**, in sequence.
- Handle high write volumes and time-based queries well.

**Examples:** InfluxDB, TimescaleDB
**Used in:** attendance tracking, server CPU metrics, IoT sensors, monitoring

## 6. In-Memory Databases

- Store data in **RAM**, so access is extremely fast.
- Data is volatile (RAM is not permanent storage).

**Examples:** Redis, Memcached
**Used in:** caching, session management, real-time analytics

## 7. Comparison Table

| Type | Data model | Schema | Best for | Examples |
|---|---|---|---|---|
| Relational (SQL) | Tables (rows and columns) | Fixed | ERP, banking, HR | MySQL, PostgreSQL |
| Document | JSON-like documents | Flexible | Blogs, CMS, profiles | MongoDB |
| Key-Value | Key and value pairs | Flexible | Caching, sessions | DynamoDB, Redis |
| Graph | Nodes and edges | Flexible | Social, recommendations | Neo4j, Neptune |
| Time-Series | Timestamped records | Flexible | Monitoring, IoT | InfluxDB |
| In-Memory | RAM-based | Flexible | Caching, real-time | Redis, Memcached |

## 8. SQL vs NoSQL (Quick View)

| | SQL | NoSQL |
|---|---|---|
| Schema | Fixed | Flexible |
| Structure | Tables | Documents, key-value, etc. |
| Strength | Integrity, relationships | Flexibility, scale |
| Example | MySQL | MongoDB |

## 9. Why This Matters for DevOps and Cloud

- **DevOps:** keep databases **up**, backed up, fast and scalable.
- **Cloud architects:** pick the right database for the app (SQL for strict integrity, NoSQL for large flexible data).
- **Developers:** know the schema and the query language (SQL or NoSQL).

## Quick Summary

1. A database replaces physical files with real-time, shared, reliable storage.
2. **SQL** = tables, fixed schema, keys and relationships (MySQL, PostgreSQL).
3. **NoSQL** = flexible schema (MongoDB = document, DynamoDB = key-value).
4. **Graph** = relationships (Neo4j).
5. **Time-series** = timestamped data (InfluxDB).
6. **In-memory** = RAM, super fast (Redis, Memcached).
7. Choose the database type based on the app's needs.