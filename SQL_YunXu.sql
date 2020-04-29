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
SELECT customerNumber, customerName, CONCAT(firstName,' ', lastName) AS employeeName FROM employees JOIN customers
ON customers.salesRepEmployeeNumber = employees.employeeNumber;
-- 2. Report total payments for Atelier graphique.
SELECT SUM(amount) FROM payments JOIN customers
ON customers.customerNumber = payments.customerNumber
WHERE customerName = "Atelier graphique";
-- 3. Report the total payments by date
SELECT SUM(amount), paymentDate FROM payments
GROUP BY paymentDate
ORDER BY paymentDate;
-- 4. Report the products that have not been sold.
SELECT * FROM products 
WHERE productCode NOT IN (SELECT products.productCode FROM products JOIN orderdetails ON products.productCode = orderdetails.productCode);
-- OR another way I think
SELECT * FROM products 
WHERE productCode NOT IN (SELECT orderdetails.productCode FROM orderdetails);
-- 5. List the amount paid by each customer.
SELECT customerName, SUM(amount) FROM payments JOIN customers
ON payments.customerNumber = customers.customerNumber
GROUP BY customerName;
-- 6. How many orders have been placed by Herkku Gifts?
SELECT COUNT(*) FROM orders 
JOIN customers on orders.customerNumber = customers.customerNumber
WHERE customerName = "Herkku Gifts";
-- How many products have been ordered by Herkku Gifts?
SELECT SUM(quantityOrdered) as Total FROM orderdetails 
JOIN orders ON orderdetails.orderNumber = orders.orderNumber
JOIN customers ON orders.customerNumber = customers.customerNumber
WHERE customerName = "Herkku Gifts";
-- 7. Who are the employees in Boston?
SELECT employeeNumber, lastName, firstName FROM employees 
JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
WHERE city = "Boston";
-- 8. Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
SELECT customerName, SUM(amount) FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
GROUP BY customerName
HAVING SUM(amount) > 100000
ORDER BY SUM(amount) DESC; 
-- 9. List the value of 'On Hold' orders.
SELECT SUM(quantityOrdered*priceEach) as OrderValues FROM orderdetails
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE status = "On Hold";
-- 10. Report the number of orders 'On Hold' for each customer.
SELECT customerName, COUNT(orders.customerNumber) FROM customers
JOIN orders ON orders.customerNumber = customers.customerNumber
WHERE status = "On Hold"
GROUP BY orders.customerNumber;

-- $Many to many relationship$
-- 1. List products sold by order date.
SELECT products.productCode, products.productName, orders.orderDate FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
ORDER BY orders.orderDate
-- 2. List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
SELECT products.productCode, products.productName, orders.orderDate FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE products.productName = "1940 Ford Pickup Truck"
ORDER BY orders.orderDate DESC;
-- 3. List the names of customers and their corresponding order number where a particular order from that customer has a value greater than $25,000?
SELECT customers.customerNumber, customers.customerName, orders.orderNumber, SUM(quantityOrdered*priceEach) AS total FROM customers 
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY orderNumber
HAVING total > 25000;
-- 4. Are there any products that appear on all orders?

-- 5. List the names of products sold at less than 80% of the MSRP.
SELECT * FROM products
WHERE buyPrice < 0.8*MSRP;
-- 6. Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
SELECT products.productCode, products.productName FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
WHERE orderdetails.priceEach > 2*products.buyPrice
GROUP BY productCode; 
-- 7. List the products ordered on a Monday.
SELECT orders.orderNumber, products.productName FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE week(orders.orderDate) = 'Monday';
-- 8. What is the quantity on hand for products listed on 'On Hold' orders?
SELECT orders.orderNumber, orderdetails.productCode, products.productName, products.quantityInStock FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE orders.status = 'ON HOLD';

-- $Regular expressions$
-- 1. Find products containing the name 'Ford'.
SELECT * FROM products
WHERE productName like '%Ford%';
-- 2. List products ending in 'ship'.
SELECT * FROM products
WHERE productName regexp 'ship$';
-- 3. Report the number of customers in Denmark, Norway, and Sweden.
SELECT * FROM customers
WHERE country = 'Denmark'
OR country = 'Norway'
OR country = 'Sweden';
-- 4. What are the products with a product code in the range S700_1000 to S700_1499?
SELECT * FROM products
WHERE productCode regexp 'S700_1[0-4][0-9][0-9]';
-- 5. Which customers have a digit in their name?
SELECT * FROM customers
WHERE customerName regexp '[0-9]';
-- 6. List the names of employees called Dianne or Diane.
SELECT * FROM employees
WHERE firstName regexp 'Dianne|Diane'
OR lastName regexp 'Dianne|Diane';
-- 7. List the products containing ship or boat in their product name.
SELECT * FROM products
WHERE productName like '%ship%'
OR productName like '%boat%';
SELECT * FROM products
WHERE productName regexp 'ship|boat';
-- 8. List the products with a product code beginning with S700.
SELECT * FROM products
WHERE productCode regexp '^S700';
-- 9. List the names of employees called Larry or Barry.
SELECT * FROM employees
WHERE firstName regexp 'Larry|Barry'
OR lastName regexp 'Larry|Barry';
-- 10. List the names of employees with non-alphabetic characters in their names.
SELECT * FROM employees
WHERE firstName regexp '\W'
OR lastName regexp '\W';
-- 11. List the vendors whose name ends in Diecast
SELECT * FROM products
WHERE productVendor regexp 'Diecast$';

-- $General queries$
-- 1. Who is at the top of the organization (i.e.,  reports to no one).
SELECT * FROM employees
WHERE reportsTo IS null;
-- 2. Who reports to William Patterson?
SELECT * FROM employees
WHERE reportsTo = (SELECT employeeNumber FROM employees WHERE lastName = 'Patterson' AND firstName = 'William');
-- 3. List all the products purchased by Herkku Gifts.
SELECT productName FROM products
JOIN orderdetails ON products.productCode = orderdetails.productCode
JOIN orders ON orderdetails.orderNumber = orders.orderNumber
WHERE orders.customerNumber = (SELECT customerNumber FROM customers WHERE customerName = 'Herkku Gifts');
-- 4. Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. Sort by employee last name and first name.
SELECT employeeNumber, firstName, lastName, SUM(0.05*quantityOrdered*priceEach) as total_commission FROM employees
JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY employeeNumber
ORDER BY firstName;
-- 5. What is the difference in days between the most recent and oldest order date in the Orders file?
SELECT datediff(MAX(orderDate), MIN(orderDate)) as DaysDifference FROM orders;
-- 6. Compute the average time between order date and ship date for each customer ordered by the largest difference.
SELECT customerName, avg(datediff(shippedDate, orderDate)) as diff FROM orders
JOIN customers ON orders.customerNumber = customers.customerNumber
GROUP BY orders.customerNumber
ORDER BY diff DESC
-- 7. What is the value of orders shipped in August 2004? (Hint).
SELECT SUM(quantityOrdered*priceEach) as OrderValue FROM orderdetails 
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE year(shippedDate) = 2004
AND monthname(shippedDate) = 'August';
-- 8. Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 and payments received in 2004 (Hint; Create views for the total paid and total ordered).
CREATE VIEW total_order AS
SELECT orders.customerNumber, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) as totalordervalue FROM orders
JOIN orderdetails ON orderdetails.orderNumber = orders.orderNumber
WHERE YEAR(orders.orderDate)=2004
GROUP BY orders.customerNumber;

CREATE VIEW total_paid AS
SELECT orders.customerNumber, SUM(payments.amount) as totalpaidvalue FROM payments
JOIN orders ON orders.customerNumber = payments.customerNumber
WHERE YEAR(orders.orderDate)=2004
GROUP BY orders.customerNumber;

SELECT total_order.customerNumber, total_order.totalordervalue, total_paid.totalpaidvalue, (totalpaidvalue-totalordervalue) as difference FROM total_order
JOIN total_paid ON total_order.customerNumber = total_paid.customerNumber
ORDER BY customerNumber
 
-- 9. List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function to combine the employee's first name and last name into a single field for reporting.
SELECT CONCAT(firstName, lastName) as EmployeeName FROM employees
WHERE reportsTo = (SELECT employeeNumber FROM employees WHERE firstName = 'Diane' AND lastName = 'Murphy');
-- 10. What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).
SELECT productCode, productName, quantityInStock*100/total.sum AS percentageOfTotal FROM products
CROSS JOIN (SELECT SUM(quantityInStock) AS sum FROM products) total
ORDER BY percentageOfTotal DESC
-- 11. Write a function to convert miles per gallon to liters per 100 kilometers.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `litersPer100kilo`(input decimal(10)) RETURNS decimal(10,0)
    DETERMINISTIC
BEGIN
RETURN 235.21/input;
END
DELIMITER ;
SELECT litersPer100kilo(27);

-- 12. Write a procedure to increase the price of a specified product category by a given percentage. You will need to create a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `increasePrice`(
IN product_Code VARCHAR(50), 
IN percentageIncrease decimal(10))
BEGIN
	UPDATE products
    SET MSRP = MSRP*(1+percentageIncrease/100)
    WHERE product_Code = productCode;
    
END $$
DELIMITER ;

CALL increasePrice('S10_1949',10);

-- 13. What is the value of orders shipped in August 2004? (Hint).
SELECT SUM(quantityOrdered*priceEach) as OrderValue FROM orderdetails 
JOIN orders ON orders.orderNumber = orderdetails.orderNumber
WHERE year(shippedDate) = 2004
AND monthname(shippedDate) = 'August';

-- (not solved) 14. What is the ratio the value of payments made to orders received for each month of 2004. (i.e., divide the value of payments made by the orders received)?
DROP VIEW paymentOrderValue;
CREATE VIEW paymentOrderValue AS
SELECT SUM(payments.amount) AS paymentValue, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) as OrderValue, month(payments.paymentDate) AS eachMonth FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN payments ON payments.customerNumber = orders.customerNumber
WHERE year(payments.paymentDate)=2004
GROUP BY month(payments.paymentDate)
ORDER BY month(payments.paymentDate);
SELECT OrderValue/paymentValue as ratio, eachMonth FROM paymentOrderValue;

-- 15. What is the difference in the amount received for each month of 2004 compared to 2003?
DROP VIEW amount2004;
CREATE VIEW amount2004 AS
SELECT SUM(amount) AS amount4, month(paymentDate) AS month4 FROM payments
WHERE year(paymentDate) = 2004
GROUP BY month(paymentDate)
ORDER BY month(paymentDate);

DROP VIEW amount2003;
CREATE VIEW amount2003 AS
SELECT SUM(amount) AS amount3, month(paymentDate) AS month3 FROM payments
WHERE year(paymentDate) = 2003
GROUP BY month(paymentDate)
ORDER BY month(paymentDate);

SELECT amount2004.month4, amount3, amount4, (amount3-amount4) AS diff FROM amount2004
JOIN amount2003 ON amount2003.month3 = amount2004.month4;

-- 16 Write a procedure to report the amount ordered in a specific month and year for customers containing a specified character string in their name.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `orderAmountChecker`(IN months INT, IN years INT, IN nameChara VARCHAR(50))
BEGIN
SELECT customers.customerName, customers.customerNumber, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) as OrderValue FROM orders
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN customers ON customers.customerNumber = orders.customerNumber
WHERE month(orders.orderDate) = months
AND year(orders.orderDate) = years
AND customers.customerName LIKE CONCAT('%',nameChara,'%')
GROUP BY customers.customerNumber;
END
DELIMITER ;
CALL orderAmountChecker(2,2003,'imports');


-- 17 Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `limitPercenChange`(IN countries VARCHAR(50), IN percentage decimal)
BEGIN
update customers
SET creditLimit = creditLimit*(1+percentage/100)
WHERE country = countries;
END
DELIMITER ;
SET SQL_SAFE_UPDATES=0;
CALL limitPercenChange('France',10);
SELECT * from customers;
SET SQL_SAFE_UPDATES=1;


-- 18 (Not Solved)Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products are often purchased together. Report the names of products that appear in the same order ten or more times.
select r1.orderNumber as orderNumber,r1.productCode as p1, r2.productCode as p2, count(*)
from orderdetails as r1
join 
orderdetails as r2
on r1.orderNumber = r2.orderNumber
where r1.productCode !=r2.productCode
group by  r1.productCode, r2.productCode
having count(*) >=10

-- 19 ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each customer's revenue as a percentage of total revenue. Sort by customer name.
SELECT SUM(payments.amount) AS revenue, SUM(payments.amount)/(SELECT SUM(payments.amount) FROM payments) AS ratio,  payments.customerNumber AS customerNumbers, customers.customerName AS customerNames FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
GROUP BY payments.customerNumber
ORDER BY customerNames

-- 20 Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a percentage of total profit. Sort by profit descending.

Compute the revenue generated by each sales representative based on the orders from the customers they serve.
Compute the profit generated by each sales representative based on the orders from the customers they serve. Sort by profit generated descending.
Compute the revenue generated by each product, sorted by product name.
Compute the profit generated by each product line, sorted by profit descending.
Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
Compute the ratio of payments for each customer for 2003 versus 2004.
Find the products sold in 2003 but not 2004.
Find the customers without payments in 2003.


