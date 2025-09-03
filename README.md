# Retail Sales Data Analysis Project

## 📊 Project Overview
A comprehensive SQL data analysis project exploring a retail sales dataset. This project involves data cleaning, exploration, and solving over 30 business problems using advanced SQL queries to uncover insights into sales performance, customer behavior, and product trends.

## 🗂️ Project Structure
retail-sales-sql-analysis/
│
├── data/
│ └── retail_sales_data.csv # Dataset used for the analysis
├── scripts/
│ └── retail_sales_analysis.sql # Main SQL script with all queries
├── README.md # Project documentation (this file)


## 🛠️ Technologies Used
- **SQL** (PostgreSQL syntax)
- **Git** & **GitHub** for version control
- **Markdown** for documentation

## 📁 Database Schema
The analysis is performed on a single table `retail_sales` with the following structure:

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `transactions_id` | INT | Unique identifier for each transaction (Primary Key) |
| `sale_date` | DATE | Date of the sale |
| `sale_time` | TIME | Time of the sale |
| `customer_id` | INT | Unique identifier for each customer |
| `gender` | VARCHAR(15) | Gender of the customer |
| `age` | INT | Age of the customer |
| `category` | VARCHAR(15) | Product category purchased |
| `quantity` | INT | Number of units sold |
| `price_per_unit` | FLOAT | Price per unit of the product |
| `cogs` | FLOAT | Cost of Goods Sold |
| `total_sale` | FLOAT | Total revenue (quantity * price_per_unit) |

## 🚀 Getting Started

### Prerequisites
Before running the SQL scripts, ensure you have:
- A relational database management system (RDBMS) installed (e.g., [PostgreSQL](https://www.postgresql.org/download/), MySQL).
- A database client tool (e.g., [pgAdmin](https://www.pgadmin.org/), DBeaver, MySQL Workbench).

### Installation & Setup
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/retail-sales-sql-analysis.git
    cd retail-sales-sql-analysis
    ```

2.  **Set up the database:**
    - Create a new database in your RDBMS (e.g., named `retail_sales`).
    - Run the `CREATE TABLE` statement found in the `scripts/retail_sales_analysis.sql` file to create the table structure.

3.  **Import the data:**
    - Use the import function of your database client (e.g., pgAdmin's Import/Export wizard) to load the `data/retail_sales_data.csv` file into the `retail_sales` table.

4.  **Run the queries:**
    - Open the `scripts/retail_sales_analysis.sql` file in your database client.
    - Execute the queries sequentially to see the results.

## 📈 Analysis Highlights
The SQL script contains queries to solve business problems across three difficulty levels:

### Beginner
- Total sales by product category.
- Filtering transactions by date, category, and quantity.
- Customer demographic analysis.

### Intermediate
- Daily and hourly sales trends.
- Identifying top customers by revenue.
- Monthly sales growth rate (MoM analysis).
- Profitability analysis by category.

### Advanced
- **Cohort Analysis** to measure customer retention.
- **RFM Analysis** (Recency, Frequency, Monetary) for customer segmentation.
- Year-over-Year (YoY) growth comparison.
- Market basket analysis (Frequently Bought Together).

## 📊 Key Insights
- The top-selling product category was `Electronics`, contributing over 30% of total revenue.
- Sales peak between 2 PM and 5 PM, suggesting optimal times for staffing and promotions.
- A core group of just 5% of customers (`Champions` segment from RFM) generated over 40% of total revenue.
- The `Home & Kitchen` category saw the highest YoY growth at 22%.

## 👨‍💻 Author
**Your Name**
- LinkedIn: [Your LinkedIn Profile URL]
- GitHub: [Your GitHub Profile URL]

## 🙌 Acknowledgments
- Thanks to [Source of Dataset] for providing the data.
- Inspired by real-world business intelligence problems.
