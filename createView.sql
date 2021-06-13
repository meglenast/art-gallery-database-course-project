--Views

--1. The view shows the products associated with every order with status N'completed'.
--The rows are ordered by id_order.
CREATE VIEW v_order_products AS
WITH order_paintings(id_order,id_product, purchase_type) AS(
		SELECT id_order, id_painting, N'picture' AS purchase_type 
		FROM orders o JOIN painting_shoppingcart psc ON o.id_cart = psc.id_cart
		WHERE o.status = N'completed'
	),
order_tickets(id_order,id_product,purchase_type) AS(
	SELECT id_order, id_ticket, N'ticket' AS purchase_type 
	FROM orders o JOIN shopping_cart sc ON o.id_cart = sc.id_cart
		JOIN ticket t ON sc.id_cart = t.id_ticket
	WHERE o.status = N'completed')
SELECT * FROM
	order_paintings
UNION
SELECT * FROM 
	order_tickets
ORDER BY id_order;

--select * from v_order_products

--2. The view shows categorization for the paintings with respect to their price
CREATE VIEW v_paintings_price_category AS 
SELECT id_painting, 
	title, 
	price_bought, 
	CASE 
		WHEN price_bought < 1000 THEN N'Low price'
		WHEN price_bought >= 1000 AND price_bought  <= 10000 THEN N'Medium price' 
		WHEN price_bought > 10000 THEN 'High price'
	END category
FROM painting
ORDER BY id_painting;

select * from v_paintings_price_category;

--3. The view shows all the paintings which have lowered their price by more than 20 percents
CREATE  VIEW v_paintings_lower_price AS
SELECT id_painting, price_bought, price_sell
FROM painting
WHERE price_sell < price_bought - (price_bought*0.2);

--select * from v_paintings_lower_price

--3. The shows for each artist their most expensive painting
CREATE  VIEW v_artist_top_painting AS
SELECT p.id_artist, p.id_painting, p.price_bought
FROM artist a JOIN painting p ON a.id_artist = p.id_artist 
WHERE p.price_bought = (SELECT max(price_bought)
						 FROM painting cp
						 WHERE p.id_painting = cp.id_painting);

--4.The view shows a statisc for the number of paintingsi in each price category
CREATE VIEW v_paintings_price_stat AS
SELECT (SELECT COUNT(*) 
		FROM painting
	   	WHERE price_bought < 1000)as low_price,
		(SELECT COUNT(*) 
		FROM painting
	   	WHERE price_bought >= 1000 and price_bought < 10000)as middel_price,
		(SELECT COUNT(*) 
		FROM painting
	   	WHERE price_bought > 10000)as high_price;

--SELECT * FROM v_paintings_price_stat;
--5.The view shows a statistic for the number of paintings sold by every artist
CREATE VIEW v_artist_num_paintings_stat AS
SELECT a.id_artist, COUNT(p.id_painting) as cnt_painting
FROM artist a JOIN painting p ON a.id_artist = p.id_artist
	JOIN painting_shoppingcart ps on p.id_painting = ps.id_painting
	JOIN orders o on ps.id_cart = o.id_cart
WHERE o.status = N'completed'
GROUP BY a.id_artist;

--SELECT * FROM v_artist_num_paintings_stat;
CREATE VIEW v_succesful_orders_info AS
SELECT id_order, o.id_cart, ord_date AS date, string_agg(title, ',') AS products
FROM orders o JOIN shopping_cart sc ON o.id_cart = sc.id_cart
			JOIN painting_shoppingcart ps ON sc.id_cart = ps.id_cart
			JOIN painting p ON p.id_painting = ps.id_painting
WHERE status = 'completed'
GROUP BY(id_order,o.id_cart);