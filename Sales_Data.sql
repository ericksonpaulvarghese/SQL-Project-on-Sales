SELECT * FROM data.sales;

SELECT 
    city,
    COUNT(DISTINCT sale_id) AS total_customers
FROM data.sales
GROUP BY city;
# Findings
# Total Customers for Chicago location = 330
# Total Customers for Los Angeles location = 326
# Total Customers for New York location = 344

#Loyalty: Percentage of membership for each store.
SELECT 
    city,
    ROUND((SUM(CASE WHEN customer_type = 'Member' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) AS percentage_members
FROM data.sales
GROUP BY city;
# Findings
# Percentage of Customers that are Members for New York = 51.5%
# Percentage of Customers that are Members for Los Angeles = 49.4%
# Percentage of Customers that are Members for Chicago = 53.9%

#Gender Bias: Percentage of Male and percentage of Female customers per store.
SELECT 
    city,
    ROUND((SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) AS percentage_of_male_customers,
    ROUND((SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) AS percentage_of_female_customers
FROM data.sales
GROUP BY city;
# Findings
# Male vs Female Customers for New York location = 50% Male and 50% Female
# Male vs Female Customers for Los Angeles location = 52.8% Male and 47.2% Female
# Male vs Female Customers for Chicago location = 55.8% Male and 44.2% Female

#Total numbers of transactions over $100 per store.
SELECT 
    city,
    COUNT(*) AS orders_over_100_dollars
FROM data.sales
WHERE total_price > 100
GROUP BY city;
# Findings
# Total Big Spender Transactions for Chicago location = 170
# Total Big Spender Transactions for Los Angeles location = 136
# Total Big Spender Transactions for New York location = 160

# Top-Selling Products: Products contributing the most to sales.
SELECT 
    product_name, 
    SUM(total_price) AS total_sales
FROM Sales
GROUP BY product_name
ORDER BY total_sales DESC LIMIT 3;
# Findings
# Highest sales contribution: Shampoo - $27,041.36
# 2nd Highest sales contribution: Notebook - $24,792.98
# 3rd Highest sales contribution: Orange Juice - $24,686.46

#Top-Selling Products Per Store: Products contributing the most to sales in each store.
SELECT 
    city,
    product_name,
    SUM(total_price) AS total_sales
FROM data.sales
GROUP BY city, product_name
ORDER BY city, total_sales DESC;
# Findings
# Top 2 Sales Contributors for Chicago
# Orange Juice - $10,123.48
# Shampoo - $10,112.73

#Top-Selling Category: Product Categories contributing the most to sales.
SELECT 
    product_category, 
    SUM(total_price) AS total_sales
FROM data.sales
GROUP BY product_category
ORDER BY total_sales DESC;
# Findings 
# Top Category: Personal Care - $27,050.18
# 2nd Top Category: Fruits - $26,197.45
# 3rd Top Category: Beverages - $22,983.32

#Top-Selling Category: Product Category contributing the most to sales per location.
SELECT city, product_category, total_sales
FROM (
    SELECT 
        city, 
        product_category, 
        SUM(total_price) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY SUM(total_price) DESC) AS category_rank
    FROM data.sales
    GROUP BY city, product_category
) AS ranked
WHERE category_rank = 1
ORDER BY city;
# Findings
# Chicago highest contributing category is Stationary at $9,810.67
# Los Angeles highest contributing category is Fruits at $8,864.57
# New York highest contributing category is Personal Care at $10,175.68

# Find the Total Revenue by city and branch.

# Total Revenue by City
SELECT 
    city,
    ROUND(SUM(total_price),0) AS total_revenue_per_location
FROM data.sales
GROUP BY city;
# Findings 
# Total Revenue for New York = 40,227
# Total Revenue for Los Angeles = 35,772
# Total Revenue for Chicago = 42,585

#Total Revenue by Branch
SELECT 
    branch,
    ROUND(SUM(total_price),0) AS total_revenue_per_branch
FROM data.sales
GROUP BY branch;
# Findings 
# Total Revenue for Branch A = 82,812
# Total Revenue for Branch B = 35,772

#Find the average basket size of all orders in each city location.
 SELECT 
    city,
    ROUND(AVG(quantity),1) AS average_quantity_per_location
FROM data.sales
GROUP BY city;
# Findings
# Average basket size per customer in New York = 9.7
# Average basket size per customer in Los Angeles = 10.3
# Average basket size per customer in Chicago = 11.0

#Find the average basket size of all orders in each branch.
 SELECT 
    branch,
    ROUND(AVG(quantity),1) AS average_quantity_per_branch
FROM data.sales
GROUP BY branch;
# Findings
# Average basket size per customer in Branch A = 10.4
# Average basket size per customer in Branch B = 10.3