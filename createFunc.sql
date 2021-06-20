--Funcutions

--1. Returns whether a picture can be added in a exhibtion_hall for a certain exhibition 
--refferred by id_exhibition and id_hall;
CREATE FUNCTION fnc_can_add_to_exhibition_hall(id_exh INT, id_h INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE
	free_places INTEGER;
BEGIN
	SELECT * 
	INTO free_Places
	FROM fnc_num_free_places_for_hall_exhibition(id_exh, id_h);
	
	IF free_places > 0 THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$;

--2. Returns the number of pictures in a exhibition hall for a certain exhibition.
-- The return value is 0 when there is no exhivition exsisting with the passed id_exhibition ad id_hall
CREATE FUNCTION fnc_num_free_places_for_hall_exhibition(id_exh INT, id_h INT)
RETURNS INT
LANGUAGE plpgsql
AS
$$
DECLARE
	cnt INTEGER;
	cap INTEGER;
BEGIN
	SELECT COUNT(*)
	INTO cnt
	FROM exhibition_hall_painting
	WHERE id_exhibition = id_exh AND id_hall = id_h;
	
	IF cnt = 0 THEN
		RETURN 0;
	ELSE
		SELECT capacity
		INTO cap
		FROM exhibition_hall
		WHERE id_hall = id_h;
		RETURN cap - cnt;
	END IF;
END;
$$;

--3.Checks wheather ther is such a order corresponding to the cart_id paseed 
--which status is N'compleated';
CREATE FUNCTION fnc_exist_order_for_cart(id_c INTEGER)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
$$
DECLARE
	cnt INTEGER;
BEGIN
	SELECT COUNT(*) 
	INTO cnt
	FROM orders
	WHERE id_cart = id_c AND status = N'completed';

	IF cnt = 1 THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$;

--4. Returns the table with all unlogged failed orders
CREATE OR REPLACE FUNCTION fnc_unlogged_orders()
RETURNS TABLE(
	id_order INT,
	cardNo CHAR(12),
	id_card INT,
	ord_date DATE,
	status CHAR(9)
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT o.id_order, o.cardNo, o.id_cart, o.ord_date, o.status
		FROM orders o LEFT JOIN log_table_declined_orders l ON o.id_order = l.id_order
		WHERE l.id_order IS NULL AND o.status = N'declined';
END;
$$;

--5. Returns card's expiration date by  passing card's number
CREATE OR REPLACE FUNCTION fnc_get_exp_date_card(card_no CHAR(12))
RETURNS DATE
LANGUAGE plpgsql
AS $$
DECLARE
exp_date DATE;
BEGIN
	SELECT expiration_date
	INTO exp_date
	FROM payment
	WHERE payment.cardNo = card_no;
	
	RETURN exp_date;
END;
$$;

--6. Returns card's balance by  passing card's number
CREATE OR REPLACE FUNCTION fnc_get_balance_card(card_no CHAR(12))
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
curr_balance NUMERIC(15,2);
BEGIN
	SELECT balance
	INTO curr_balance
	FROM payment
	WHERE payment.cardNo = card_no;
	
	RETURN curr_balance;
END;
$$;

--7. Returns tickets price
CREATE OR REPLACE FUNCTION fnc_get_ticket_price(id INT)
RETURNS NUMERIC(4,2)
LANGUAGE plpgsql
AS $$
DECLARE
exh_price NUMERIC(4,2);
curr_type CHAR(7);
BEGIN
	SELECT price_ticket
	INTO exh_price
	FROM exhibition
	WHERE id_exhibition = (SELECT id_exhibition
						   FROM ticket
						   WHERE id_ticket = id);
	
	SELECT type
	FROM ticket
	INTO curr_type
	WHERE id_ticket = id;
	
	CASE
		WHEN curr_type = N'adult' THEN
			RETURN exh_price;
		WHEN curr_type = N'child' OR curr_type = N'elder' THEN
			RETURN exh_price - 0.5*exh_price;
		ELSE 
			RETURN exh_price - 0.35*exh_price;
	END CASE;
END;
$$