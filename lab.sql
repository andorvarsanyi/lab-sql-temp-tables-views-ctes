USE sakila;

CREATE VIEW customer_rental_summary AS
SELECT 
    customer.customer_id,
    CONCAT(customer.first_name, ' ', customer.last_name) AS name,
    customer.email,
    COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

CREATE TEMPORARY TABLE customer_payment_summary AS
SELECT 
    customer_rental_summary.customer_id,
    SUM(payment.amount) AS total_paid
FROM customer_rental_summary
JOIN payment ON customer_rental_summary.customer_id = payment.customer_id
GROUP BY customer_rental_summary.customer_id;

WITH customer_summary AS (
    SELECT 
        crs.name,
        crs.email,
        crs.rental_count,
        cps.total_paid,
        (cps.total_paid / crs.rental_count) AS average_payment_per_rental
    FROM customer_rental_summary crs
    JOIN customer_payment_summary cps ON crs.customer_id = cps.customer_id
)
SELECT 
    name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
FROM customer_summary;
