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

--drop function fnc_can_add_to_exhibition_hall;
--select * from fnc_can_add_to_exhibition_hall(1004, 1004);
--select * from fnc_can_add_to_exhibition_hall(1003, 1009);
--select * from fnc_can_add_to_exhibition_hall(1090, 1000);

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

--drop FUNCTION fnc_num_free_places_for_hall_exhibition;
--select * from exhibition_hall;
--select * from exhibition_hall_painting;
--select * from fnc_num_free_places_for_hall_exhibition(1004, 1004);
--select * from fnc_num_free_places_for_hall_exhibition(1003, 1009);
--select * from fnc_num_free_places_for_hall_exhibition(1090, 1000);

--3.Checks wheather ther is such a order corresponding to the cart_id paseed 
--which status is N'compleated';
--SELECT * FROM fnc_exist_order_for_cart(4);
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
