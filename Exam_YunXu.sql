-- Question 1
SELECT city, COUNT(distinct(salesRepEmployeeNumber)) AS countEmployee FROM customers
GROUP BY city
ORDER BY countEmployee DESC;

-- Question 2
SELECT productline, ((sum(MSRP*quantityInStock)-sum(buyPrice*quantityInStock))/sum(MSRP*quantityInStock))AS profitMargin FROM products
GROUP BY productLine

-- Question 3
-- A
SELECT employeeNumber, firstName, lastName, SUM(quantityOrdered*priceEach) as total_revenue FROM employees
JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY employeeNumber
ORDER BY firstName;

-- B
