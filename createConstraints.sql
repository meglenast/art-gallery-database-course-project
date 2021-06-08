--Key constraints and check constraints

--artist
ALTER TABLE artist
	ADD CONSTRAINT 	pk_artist 	PRIMARY KEY(id_artist);

ALTER TABLE artist
	ADD CONSTRAINT ch_artist_first_name CHECK(first_name SIMILAR TO '[A-Z][a-z]+');

ALTER TABLE artist
	ADD CONSTRAINT ch_artist_last_name CHECK(first_name SIMILAR TO '[A-Z][a-z]+');

ALTER TABLE artist
	ADD CONSTRAINT ch_artist_date_of_death CHECK(EXTRACT(YEAR  FROM date_of_death) > EXTRACT(YEAR FROM date_of_birth));

ALTER TABLE artist
	ADD CONSTRAINT ch_artist_time_period 
		CHECK (time_period in (N'MiddleAge', N'Renaissance', N'18thCentury', N'19thCentury', N'20thCentury', N'21thCentury', N'Other'));

--customer
ALTER TABLE customer
	ADD CONSTRAINT pk_customer PRIMARY KEY(id_customer);
	
ALTER TABLE customer
	ADD CONSTRAINT ch_customer_passwd CHECK(passwd SIMILAR TO '%[0-9]%' AND 
									        passwd SIMILAR TO '%[A-Z]%' );
						
ALTER TABLE customer
	ADD CONSTRAINT ch_customer_first_name CHECK(first_name SIMILAR TO '[A-Z][a-z]+');

ALTER TABLE customer
	ADD CONSTRAINT ch_customer_last_name CHECK(first_name SIMILAR TO '[A-Z][a-z]+');

ALTER TABLE customer 
	ADD CONSTRAINT ch_customer_phone CHECK(phone SIMILAR TO '\+[0-9]+' OR
										   phone SIMILAR TO '[0-9]+');
											 
ALTER TABLE customer
	ADD CONSTRAINT ch_customer_email CHECK(email LIKE '%_@%_.%_');

--shopping_cart
ALTER TABLE shopping_cart
	ADD CONSTRAINT 	pk_shopping_cart PRIMARY KEY(id_cart);

ALTER TABLE shopping_cart
	ADD CONSTRAINT 	fk_shopping_cart FOREIGN KEY(id_customer) REFERENCES customer(id_customer);
	
ALTER TABLE shopping_cart
	ADD CONSTRAINT ch_shopping_cart_quantity CHECK(quantity >= 0);

ALTER TABLE shopping_cart
	ADD CONSTRAINT ch_shopping_cart_price CHECK(total_price >= 0);

--payment
ALTER TABLE payment
	ADD CONSTRAINT 	pk_payment PRIMARY KEY(cardNo);
	
ALTER TABLE payment
	ADD CONSTRAINT ch_payment_owner_firstname CHECK(owner_firstname SIMILAR TO '[A-Z][a-z]+%');

ALTER TABLE payment
	ADD CONSTRAINT ch_payment_owner_lastname CHECK(owner_lastname SIMILAR TO '[A-Z][a-z]+%');

--exhibition
ALTER TABLE exhibition
    ADD CONSTRAINT pk_exhibition PRIMARY KEY (id_exhibition);
	
ALTER TABLE exhibition
    ADD CONSTRAINT ch_exhibition_price_ticket CHECK (price_ticket >= 0::numeric);
	
ALTER TABLE exhibition
    ADD CONSTRAINT ch_exhibition_date_ending CHECK (date_ending > (date_starting + '1 day'::interval));

--exhibition_hall
ALTER TABLE exhibition_hall
    ADD CONSTRAINT pk_exhibition_hall PRIMARY KEY (id_hall);

ALTER TABLE exhibition_hall
	ADD CONSTRAINT 	ch_exhibition_hall_floor CHECK(floor >= -1 AND floor <= 4);
	
ALTER TABLE exhibition_hall
	ADD CONSTRAINT 	ch_exhibition_capacity CHECK(capacity >0);

--ticket
ALTER TABLE ticket
    ADD CONSTRAINT pk_ticket PRIMARY KEY (id_ticket);
	
ALTER TABLE ticket
	ADD CONSTRAINT 	fk_ticket_exhibition FOREIGN KEY(id_exhibition) REFERENCES exhibition(id_exhibition);

ALTER TABLE ticket
	ADD CONSTRAINT 	fk_ticket_cart FOREIGN KEY(id_cart) REFERENCES shopping_cart(id_cart);

ALTER TABLE ticket
	ADD CONSTRAINT 	ch_ticket_type CHECK(type IN (N'adult', N'child', N'student', N'elder'));
	
--orders
ALTER TABLE orders
    ADD CONSTRAINT pk_orders PRIMARY KEY (id_order);
	
ALTER TABLE orders
	ADD CONSTRAINT 	fk_orders_cardNo FOREIGN KEY(cardNo) REFERENCES payment(cardNo);

ALTER TABLE orders
	ADD CONSTRAINT 	fk_orders_id_cart FOREIGN KEY(id_cart) REFERENCES shopping_cart(id_cart);

ALTER TABLE orders
	ADD CONSTRAINT 	ch_orders_ord_date CHECK(ord_date <= NOW()::date + '1 day'::interval );

ALTER TABLE orders
	ADD CONSTRAINT 	ch_orders_status CHECK(status IN (N'completed', N'declined'));
		
 --painting 
ALTER TABLE painting
    ADD CONSTRAINT pk_painting PRIMARY KEY (id_painting);
	
ALTER TABLE painting
	ADD CONSTRAINT 	fk_painting_id_artist FOREIGN KEY(id_artist) REFERENCES artist(id_artist);
	
ALTER TABLE painting
	ADD CONSTRAINT 	ch_painting_technique CHECK(drawing_technique IN (N'oil', N'acryl', N'water colour', N'sketch', N'graphic'));

ALTER TABLE painting
	ADD CONSTRAINT 	ch_painting_price_sell CHECK(price_sell > 0);
	
ALTER TABLE painting
	ADD CONSTRAINT 	ch_painting_price_bought CHECK(price_bought > 0);

ALTER TABLE painting
	ADD CONSTRAINT 	ch_painting_num_copies CHECK(number_copies >= 0);
	
ALTER TABLE painting
	ADD CONSTRAINT 	ch_painting_type CHECK(type_painting IN (N'original', N'reproduction', N'print'));

--still_life_painting
ALTER TABLE still_life_painting
    ADD CONSTRAINT pk_still_life_painting PRIMARY KEY (id_painting);
	
ALTER TABLE still_life_painting
    ADD CONSTRAINT fk_still_life_painting FOREIGN KEY (id_painting) REFERENCES painting(id_painting);
	
--landscape_painting
ALTER TABLE landscape_painting
    ADD CONSTRAINT pk_landscape_painting PRIMARY KEY (id_painting);
	
ALTER TABLE landscape_painting
    ADD CONSTRAINT fk_landscape_painting FOREIGN KEY (id_painting) REFERENCES painting(id_painting);

--genre_painting
ALTER TABLE genre_painting
    ADD CONSTRAINT pk_genre_painting PRIMARY KEY (id_painting);
	
ALTER TABLE genre_painting
    ADD CONSTRAINT fk_genre_painting FOREIGN KEY (id_painting) REFERENCES painting(id_painting);

--portrait_art
ALTER TABLE portrait_art
    ADD CONSTRAINT pk_portrait_art PRIMARY KEY (id_painting);
	
ALTER TABLE portrait_art
    ADD CONSTRAINT fk_portrait_art FOREIGN KEY (id_painting) REFERENCES painting(id_painting);

--history_painting
ALTER TABLE history_painting
    ADD CONSTRAINT pk_history_painting PRIMARY KEY (id_painting);
	
ALTER TABLE history_painting
    ADD CONSTRAINT fk_history_painting FOREIGN KEY (id_painting) REFERENCES painting(id_painting);

--painting_shoppingcart
ALTER TABLE painting_shoppingcart
    ADD CONSTRAINT pk_painting_shoppingcart PRIMARY KEY (id);
	
ALTER TABLE painting_shoppingcart
    ADD CONSTRAINT fk_painting_shoppingcart_id_painting FOREIGN KEY (id_painting) REFERENCES painting(id_painting);
	
ALTER TABLE painting_shoppingcart
    ADD CONSTRAINT fk_painting_shoppingcart_id_cart FOREIGN KEY (id_cart) REFERENCES shopping_cart(id_cart);	

--exhibition_hall_painting
ALTER TABLE exhibition_hall_painting
	ADD CONSTRAINT pk_exhibition_hall_painting PRIMARY KEY (id);

ALTER TABLE exhibition_hall_painting
	ADD CONSTRAINT fk_exhibition_hall_painting_painting  FOREIGN KEY (id_painting) REFERENCES painting(id_painting);

ALTER TABLE exhibition_hall_painting
	ADD CONSTRAINT fk_exhibition_hall_painting_hall  FOREIGN KEY (id_hall) REFERENCES exhibition_hall(id_hall);

ALTER TABLE exhibition_hall_painting
	ADD CONSTRAINT fk_exhibition_hall_painting_exhibition  FOREIGN KEY (id_exhibition) REFERENCES exhibition(id_exhibition);