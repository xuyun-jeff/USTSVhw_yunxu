-- $Single entity$
-- 1. Prepare a list of offices sorted by country, state, city.
SELECT * FROM classicmodels.offices
ORDER BY country desc
SELECT * FROM classicmodels.offices
ORDER BY state desc
SELECT * FROM classicmodels.offices
ORDER BY city desc
-- 2. How many employees are there in the company?
SELECT COUNT(DISTINCT employeeNumber)
FROM employees;
-- 3. What is the total of payments received?
SELECT sum(amount) as total from payments;
-- 4. List the product lines that contain 'Cars'.
SELECT * FROM productlines
WHERE productline LIKE '%Cars%';
-- 5. Report total payments for October 28, 2004.
SELECT sum(amount) as total from payments
WHERE paymentDate = '2004-10-28';
-- 6. Report those payments greater than $100,000.
SELECT * FROM payments
WHERE amount > 100000; 
-- 7. List the products in each product line.
SELECT * FROM products
ORDER BY productLine;
-- 8. How many products in each product line?
SELECT DISTINCT productline, (SELECT COUNT(productCode) FROM products) 
as cnt FROM products 
ORDER BY cnt DESC
-- 9. What is the minimum payment received?
SELECT MIN(amount) as minimum_payment, customerNumber, checkNumber, paymentDate FROM classicmodels.payments;
-- 10. List all payments greater than twice the average payment.
SELECT * FROM payments
WHERE amount > (SELECT 2*AVG(amount) FROM payments);
-- 11. What is the average percentage markup of the MSRP on buyPrice?
SELECT CONCAT(CAST(AVG((MSRP-buyPrice)/buyPrice)*100 AS DECIMAL (5,2)), '%')
AS Average FROM products;
-- 12. How many distinct products does ClassicModels sell?
SELECT COUNT(DISTINCT productCode) as cnt FROM products;
-- 13. Report the name and city of customers who don't have sales representatives?
SELECT customerName, city FROM customers
WHERE salesRepEmployeeNumber IS null
ORDER BY city;
-- 14. What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
SELECT CONCAT(firstName, lastName) AS SelectedNames, jobTitle FROM employees
WHERE jobTitle Like '%VP%' 
OR jobTitle Like '%Manager%';
-- 15. Which orders have a value greater than $5,000?
SELECT orderNumber, (quantityOrdered*priceEach) as orderValue FROM orderdetails 
WHERE quantityOrdered*priceEach > 5000
ORDER BY orderNumber;


-- $One to many relationship$
-- 1. Report the account representative for each customer.
-- 2. Report total payments for Atelier graphique.
-- 3. Report the total payments by date
-- 4. Report the products that have not been sold.
-- 5. List the amount paid by each customer.
-- 6. How many orders have been placed by Herkku Gifts?
-- 7. Who are the employees in Boston?
-- 8. Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
-- 9. List the value of 'On Hold' orders.
-- 10. Report the number of orders 'On Hold' for each customer.