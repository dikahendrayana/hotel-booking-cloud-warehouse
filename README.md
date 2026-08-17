# 🏨 Hotel Booking Cloud Data Warehouse

An end-to-end cloud data warehouse project — from raw ingestion to BI dashboard — built on **Snowflake**, using the [Hotel Booking Demand Dataset](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand) (119,390 booking records).

This project was built to demonstrate the full modern data stack: cloud data warehousing, dbt-based transformation, and BI dashboarding.

![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=postgresql&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-56B9EB?style=for-the-badge&logo=snowflake&logoColor=white)
![Metabase](https://img.shields.io/badge/Metabase-509EE3?style=for-the-badge&logo=metabase&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

---

## 🏗️ Architecture

```text
Raw CSV (119,390 rows)
        │
        ▼ Manual load into Snowflake
   RAW_HOTEL_BOOKINGS (raw layer)
        │
        ▼ staging/ (stg_hotel_bookings — dbt source())
   Cleaned 1:1 representation, 32 columns
        │
        ▼ marts/ (monthly_revenue_summary)
   Revenue = ADR × (weekend nights + week nights)
   Cancelled bookings excluded
   Grouped by month/year with a derived DATE column
        │
        ▼ Metabase (self-hosted via Docker)
   Live "Monthly Revenue Trend" dashboard
```

## 🔑 Key Design Decisions

- **Loose typing on the raw layer**: several columns (`children`, `agent`, `company`) contain non-numeric placeholder values (`"NA"`) in the source data. Rather than forcing strict numeric types at load time and losing rows, these columns were loaded as `VARCHAR` — preserving all 119,390 rows, with type coercion handled explicitly downstream in dbt.
- **Derived `booking_month` date column**: the raw data stores year and month as separate fields (`arrival_date_year`, `arrival_date_month` as a month name string). Grouping directly on the month name caused BI tools to merge data across different years (e.g., all "August" bookings from 2015–2017 into one bar). A `TO_DATE()`-derived `booking_month` column fixes this at the data layer, so any BI tool connecting to this mart sorts and groups correctly by default — not just the one currently in use.
- **Revenue business logic**: total revenue is calculated as `ADR × total nights stayed`, explicitly excluding cancelled bookings (`is_canceled = 0`), since cancelled reservations don't generate actual revenue.

## 📊 Dashboard

A live Metabase dashboard connects directly to the Snowflake mart, visualizing monthly revenue trends from July 2015 to July 2017 with a linear trendline showing overall growth.

## 🚀 Local Setup

```bash
git clone https://github.com/dikahendrayana/hotel-booking-cloud-warehouse.git
cd hotel-booking-cloud-warehouse/hotel_booking_analytics

pip install dbt-snowflake

dbt init hotel_booking_analytics
# Configure profiles.yml with your Snowflake connection:
# - account, user, password, role, warehouse, database, schema

dbt run

# Metabase (BI dashboard), self-hosted via Docker
docker run -d -p 3000:3000 --name metabase metabase/metabase
# Open http://localhost:3000, connect to your Snowflake database
```

## 📂 Project Structure

hotel_booking_analytics/
├── models/
│ ├── staging/ # stg_hotel_bookings + sources.yml
│ └── marts/ # monthly_revenue_summary
├── dbt_project.yml
└── README.md

---

## 👤 Author

**Dika Hendrayana**
* GitHub: [@dikahendrayana](https://github.com/dikahendrayana)
* LinkedIn: [Dika Hendrayana](https://linkedin.com/in/dika-hendrayana)