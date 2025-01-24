use olist_store_dataset;


# KPI - 1
# Weekday vs Weekend(order_purchase_timestamp) Payment Statistics
SELECT * FROM olist_store_dataset.olist_orders_dataset;
SELECT * FROM olist_store_dataset.olist_order_payments_dataset;

SELECT
	CASE WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) 
    IN (1, 7) THEN 'Weekend' ELSE 'Weekday' END AS DayType,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    round(SUM(p.payment_value)) AS TotalPayments,
    round(AVG(p.payment_value)) AS AveragePayment
FROM
	olist_orders_dataset o
JOIN
	olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY
	DayType;
    
# KPI - 2
#Number of Orders with review score of 5 and payment type as a credit card.



SELECT
	COUNT(DISTINCT p.order_id) AS NumberOfOrders
FROM
	olist_order_payments_dataset p 
JOIN
	olist_order_reviews_dataset r ON p.order_id = r.order_id
WHERE
	r.review_score = 5 
	AND p.payment_type = 'credit_card';
    
# KPI - 3
# The Average number of days taken for order_delivered_customers_date for pet_shop

SELECT 
	product_category_name,
    round(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))) AS avg_delivery_time
FROM 
	olist_orders_dataset o
JOIN
	olist_order_items_dataset i ON i.order_id = o.order_id
JOIN
	olist_products_dataset p ON p.product_id = i.product_id
WHERE
	p.product_category_name = 'pet_shop'
    AND o.order_delivered_customer_date IS NOT NULL;
    
#KPI - 4
#Average Price and Payment values from customers sao paulo city


SELECT 
	round(AVG(i.price)) AS average_price,
    round(AVG(p.payment_value)) AS average_payment 
FROM
	olist_customers_dataset c
JOIN
	olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN
	olist_order_items_dataset i ON o.order_id = i.order_id
JOIN
	olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE
	c.customer_city = 'Sao Paulo';


#KPI -  5
# Relationship between shipping day (order_delivered_customer_date - order_purchase_timestamp) vs Review score

SELECT
	round (AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 0) AS AvgShippingDays,
	review_score
FROM
	olist_orders_dataset o
JOIN
	olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE
	order_delivered_customer_date IS NOT NULL
	AND order_purchase_timestamp IS NOT NULL
GROUP BY
	review_score;
