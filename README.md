<div align="center">

# ✈️ Airline Database Analysis Using SQL  
### *Querying with PostgreSQL*

![Database](https://img.shields.io/badge/Database-PostgreSQL%2014-blue?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-SQL-green?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Database%20Querying-orange?style=for-the-badge)

</div>

---

## Overview

This project demonstrates the application of **SQL for data analysis and database querying** using a structured airline database.

The goal is to:
- Practice SQL querying techniques  
- Retrieve meaningful insights from relational data  
- Solve real-world (airline) analytical problems.  

The project consists of **29 structured query cases**, each addressing a specific business or analytical question.

---

## Database Structure

The database contains **8 relational tables**:

| Table Name | Description |
|----------|------------|
| `airports` | Airport details |
| `aircrafts` | Aircraft specifications |
| `boarding_passes` | Passenger boarding data |
| `bookings` | Booking records |
| `flights` | Flight schedules and routes |
| `seats` | Aircraft seating configurations |
| `tickets` | Ticket information |
| `ticket_flights` | Ticket-flight relationships |

---

## Key SQL Concepts Applied

- SELECT, WHERE, ORDER BY  
- JOIN (INNER, LEFT, etc.)  
- GROUP BY & Aggregations  
- Subqueries  
- Window functions  
- Date/time filtering  
- Case statements  
- Data transformation  

---

## Query Cases (Overview)

<details>
<summary><strong> Click to expand all query cases</strong></summary>

### Basic Queries
- Cities with no flights from Moscow  
- Airports in specific time zones  
- Aircrafts within specific range  

### Calculations & Transformations
- Convert aircraft range to miles  
- Average ticket sales  
- Min/Max ticket prices  

### Aircraft & Seating Analysis
- Number of seats per aircraft  
- Seats by class (Business/Economy)  
- Aircraft details with range  

### Flight Analysis
- Shortest flight durations  
- Flight delays > 1 hour  
- Flights per city (>50 threshold)  
- Flights departing per hour  

### Passenger Analysis
- Most frequent passenger names  
- Passengers with consistent early check-ins  
- Booking capacity analysis  

### Route & Network Analysis
- Total possible routes between cities  
- Cities with multiple airports  
- Unique city-flight-timezone combinations  

### Advanced Queries
- Longest flight delays  
- Connection times between flights  
- Free seats on specific flights  
- Historical booking and travel queries  

</details>

---

## Sample Queries

### Example 1: Aircraft Range Conversion

```sql
SELECT 
    model, 
    range, 
    ROUND(range / 1.609, 2) AS range_miles
FROM aircrafts;
```

---

### Example 2: Average Ticket Sales

```sql
SELECT AVG(amount) AS avg_ticket_sales
FROM ticket_flights;
```

---

### Example 3: Seats per Aircraft

```sql
SELECT aircraft_code, COUNT(*) AS total_seats
FROM seats
GROUP BY aircraft_code
ORDER BY total_seats ASC;
```

---

### Example 4: Flights per City (>50)

```sql
SELECT departure_city, COUNT(*) AS flight_count
FROM flights
GROUP BY departure_city
HAVING COUNT(*) > 50
ORDER BY flight_count DESC;
```

---

## Workflow

```text
Understand Database Schema
   ↓
Define Analytical Questions
   ↓
Write SQL Queries
   ↓
Test & Optimize Queries
   ↓
Extract Insights
```

---

## Key Insights

- SQL enables efficient querying of large relational datasets  
- Complex business questions can be solved with layered queries  
- Aggregations and joins are essential for multi-table analysis  
- Data-driven insights support operational and strategic decisions  

---

## Reproducibility Guide

To replicate this project:

1. Install PostgreSQL 14  
2. Load the airline dataset  
3. Connect via pgAdmin or terminal  
4. Execute queries from the cases listed  
5. Modify queries to explore additional insights  

---

## Tools/Tech Used

- PostgreSQL 14
- SQL (Structured Query Language)
