CREATE TABLE artist
(
	id_artist     INT GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1) NOT NULL,
	first_name 	  VARCHAR(30) NOT NULL,
	last_name     VARCHAR(30),
	country       VARCHAR(20),
	date_of_birth DATE,
	date_of_death DATE,
	time_period   VARCHAR(20)
);

CREATE TABLE customer
(
	id_customer INT GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1),
	first_name  VARCHAR(30) NOT NULL,
	last_name   VARCHAR(30) NOT NULL,
	passwd      VARCHAR(12) NOT NULL,
	phone       VARCHAR(20) NOT NULL,
	email       VARCHAR(40) NOT NULL UNIQUE,
	address     VARCHAR(50) NOT NULL
);

CREATE TABLE shopping_cart
(
	id_cart     INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	id_customer INT NOT NULL,
	quantity    SMALLINT, 
	total_price NUMERIC(10,2)
);

CREATE TABLE payment
(
	cardNo CHAR(12) NOT NULL,
	owner_firstname VARCHAR(30) NOT NULL,
	owner_lastname  VARCHAR(30) NOT NULL,
	expiration_date DATE NOT NULL,
	balance			NUMERIC(15,2) NOT NULL
);

CREATE TABLE exhibition
(
	id_exhibition   INT GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1),
	name_exhibition VARCHAR(30)NOT NULL,
	date_starting   DATE NOT NULL,
	date_ending     DATE NOT NULL,
	price_ticket    NUMERIC(4,2) NOT NULL
);

CREATE TABLE exhibition_hall
(
	id_hall      INT GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1),
	floor        SMALLINT NOT NULL,
	capacity     SMALLINT NOT NULL
);

CREATE TABLE ticket
(
	id_ticket     INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	id_exhibition INT NOT NULL,
	id_cart       INT, -- null when not sold
	date          DATE NOT NULL,
	type          CHAR(7) NOT NULL
);

CREATE TABLE orders
(
	id_order INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1), 
	cardNo   CHAR(12) NOT NULL,
	id_cart  INT NOT NULL,
	ord_date DATE NOT NULL, 
	status   CHAR(9) NOT NULL DEFAULT N'declined'
);
--drop table orders;
CREATE TABLE painting
(
	id_painting       INT GENERATED ALWAYS AS IDENTITY (START WITH 100000 INCREMENT BY 1),
	id_artist         INT NOT NULL,
	title             VARCHAR(50)NOT NULL,
	year_painted      DATE,
	width             NUMERIC(5,2),
	height            NUMERIC(5,2),
	drawing_technique CHAR(7),
	price_sell        NUMERIC(10,2), --NULL WHEN NOT SELLABLE
	price_bought      NUMERIC(10,2) NOT NULL,
	number_copies     SMALLINT,
	type_painting     CHAR(12)
);

CREATE TABLE still_life_painting
(
	id_painting INT NOT NULL
);

CREATE TABLE landscape_painting
(
	id_painting INT NOT NULL
);

CREATE TABLE genre_painting
(
	id_painting INT NOT NULL
);

CREATE TABLE portrait_art
(
	id_painting INT NOT NULL,
	portrayed   VARCHAR(30)
);

CREATE TABLE history_painting
(
	id_painting      INT NOT NULL,
	historical_event VARCHAR(30)
);

CREATE TABLE painting_shoppingcart
(
	id          INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	id_painting INT NOT NULL,
	id_cart     INT NOT NULL
);

CREATE TABLE exhibition_hall_painting
(
	id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	id_painting   INT NOT NULL,
	id_exhibition INT NOT NULL,
	id_hall       INT NOT NULL
);

CREATE TABLE log_table_declined_orders
(
	id  INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
	id_order INT NOT NULL,
	log_info CHAR(40)
);