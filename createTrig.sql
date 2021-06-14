--Triggers

--1. When new row in artist is inserted the trigger sets the artist's time period
CREATE FUNCTION trig_fnc_set_timeperiod()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
	year_of_death INTEGER;
BEGIN
	SELECT EXTRACT(YEAR  FROM NEW.date_of_death) INTO year_of_death; 

	CASE 
		WHEN year_of_death >= 1520 AND year_of_death < 1650 THEN
			UPDATE artist SET time_period = N'MiddleAge' WHERE id_artist = NEW.id_artist;
		WHEN year_of_death >= 1650 AND year_of_death < 1800 THEN
			UPDATE artist SET time_period = N'Renaissance' WHERE id_artist = NEW.id_artist;
		WHEN year_of_death >= 1800 AND year_of_death < 1900 THEN
			UPDATE artist SET time_period = N'19thCentury' WHERE id_artist = NEW.id_artist;
		WHEN year_of_death >= 1900 AND year_of_death < 2000 THEN
			UPDATE artist SET time_period = N'20thCentury' WHERE id_artist = NEW.id_artist;
		WHEN year_of_death >= 2000 AND year_of_death < 2100 THEN
			UPDATE artist SET time_period = N'21thCentury' WHERE id_artist = NEW.id_artist;
		ELSE
			UPDATE artist SET time_period = N'Other' WHERE id_artist = NEW.id_artist;
	END CASE;
	RETURN NEW;
END;
$$;

CREATE TRIGGER ains_artis
	AFTER INSERT
	ON artist
	FOR ROW
	EXECUTE PROCEDURE trig_fnc_set_timeperiod();
	
--SELECT * FROM ARTIST;
--insert into artist (first_name, last_name, country, date_of_birth, date_of_death) values ('Adria', 'Aguirrezabal', 'Thailand', '1951-05-02', '1964-12-22');

--2. After insert checks  whether the picture can be inserted in the certain exhibition and hall
--If not triggers a function which deletes the row.
CREATE FUNCTION trig_fnc_set_picture_in_hall()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
	id_exhibition INTEGER;
	id_hall INTEGER;
BEGIN
		SELECT NEW.id_exhibition INTO id_exhibition;
		SELECT NEW.id_hall INTO id_hall;
		
		IF  NOT fnc_can_add_to_exhibition_hall(id_exhibition, id_hall) THEN
			DELETE FROM exhibition_hall_painting WHERE id = NEW.id;
		END IF;
		RETURN NEW;
END;
$$;

CREATE TRIGGER ains_picture_hall
	AFTER INSERT
	ON exhibition_hall_painting
	FOR ROW
	EXECUTE PROCEDURE trig_fnc_set_picture_in_hall();
	
--select * from exhibition_hall_painting;
--insert into exhibition_hall_painting (id_painting, id_exhibition, id_hall) values (100002,1004,1004);

--3. Afer insert in relation orders, checks wheather the card associated with the cardNo is valid.
--If not the trigger function sets the order's status as N'declined' otherwise sets the order's status as N'compleated'
CREATE FUNCTION trig_fnc_set_order_status()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
	card_exp_date DATE;
BEGIN
	SELECT expiration_date expiration_date
	INTO card_exp_date
	FROM payment p JOIN orders o ON p.CardNo = o.CardNo
	WHERE o.id_order = NEW.id_order;
	
	IF card_exp_date < CURRENT_DATE THEN
		UPDATE orders SET status = N'declined' WHERE id_order = NEW.id_order;
	ELSE
		UPDATE orders SET status = N'completed' WHERE id_order = NEW.id_order;
	END IF;
	RETURN NEW;
END;
$$;

CREATE TRIGGER ains_orders
	AFTER INSERT
	ON orders
	FOR ROW
	EXECUTE PROCEDURE trig_fnc_set_order_status();

--4. Before insert in relation orders, checks wheather the cart associated with the id_cart is already add as order with status  N'compleated'.
--If it is the trigger does not add new order.
CREATE OR REPLACE FUNCTION trig_fnc_ins_order()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
	been_completed BOOL;
BEGIN
	SELECT *
	INTO been_completed
	FROM fnc_exist_order_for_cart(NEW.id_cart);
	
	IF been_completed = TRUE THEN
		RAISE EXCEPTION '% The order assosiated with this shopping cart is already completed', NEW.id_cart;
		RETURN NULL;
	END IF;
	RETURN NEW;
END;
$$;
DROP TRIGGER IF EXISTS bins_orders ON orders;
CREATE TRIGGER bins_orders
	BEFORE INSERT
	ON orders
	FOR ROW
	EXECUTE PROCEDURE trig_fnc_ins_order();
--select * from orders ;
--insert into orders (cardNo, id_cart, ord_date) values ('304596354637', 4, '2020-08-13');

--select * from payment;
--select * from orders;
