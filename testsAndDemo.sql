--Tests and demo--

--Funcutions

--1 fnc_num_free_places_for_hall_exhibition(id_exh INT, id_h INT)

--We can see that there is only one row in the table exhibition_hall_painting. 
select * from exhibition_hall_painting;

--Ex.Existing hall with 

--Let's see the capcity of hall with id 1009.
select * from exhibition_hall where id_hall = 1009;
--Let's see the number of free places for hall
select * from fnc_num_free_places_for_hall_exhibition(1003, 1009);
--Now let's add new painting to the hall
insert into exhibition_hall_painting (id_painting, id_exhibition, id_hall) values (100002, 1003, 1009);
--Let's see the number of free places for hall
select * from fnc_num_free_places_for_hall_exhibition(1003, 1009);

--Ex.Nonexisting hall
select * from fnc_num_free_places_for_hall_exhibition(1004, 1004);


--2 fnc_can_add_to_exhibition_hall(id_exh INT, id_h INT)

--Ex. Exisiting hall with free places.
select * from fnc_num_free_places_for_hall_exhibition(1003, 1009);
select * from fnc_can_add_to_exhibition_hall(1003, 1009);

--Ex. Existing hall with none free places.
select * from exhibition_hall_painting;
--Let's insert a painting for exhibiton 1000 in hall 1004
insert into exhibition_hall_painting (id_painting, id_exhibition, id_hall) values (100001, 1000, 1004);
--Check whether а painting can added in a full hall.
select * from fnc_can_add_to_exhibition_hall(1000, 1004);

--Ex. Nonexisting hall
select * from fnc_can_add_to_exhibition_hall(1090, 1000);

--3. fnc_exist_order_for_cart(id_c INTEGER)

select * from orders;

--declined order 
SELECT * FROM fnc_exist_order_for_cart(1);
--accepted order
SELECT * FROM fnc_exist_order_for_cart(1);


--4. fnc_unlogged_orders()
--At this point we still have't added any information to the log tabl so the function must return a 
--table with all declined orders from table orders. 
select * from  orders;
select * from  fnc_unlogged_orders()

--5. fnc_get_exp_date_card(card_no CHAR(12))
select * from  payment;
select * from fnc_get_exp_date_card('301771555836'); -- existing payment 
select * from fnc_get_exp_date_card('111111111111'); -- nonexisting payment

--6. fnc_get_balance_card(card_no CHAR(12))
select * from  payment;
select * from fnc_get_balance_card('301771555836'); -- existing payment 
select * from fnc_get_balance_card('111111111111'); -- nonexisting payment

--Stored procedures

select * from  orders;
select * from  fnc_unlogged_orders()
call proc_log_failed_orders();
select * from log_table_declined_orders;

--Triggers

--1. ains_artis
--Let's see artist table so far
select * from artist;
--Let's insert a new artist 
insert into artist (first_name, last_name, country, date_of_birth, date_of_death) values 
	('First', 'First', 'First', '1550-05-02', '1610-05-02');
--Let's insert one more artist 
insert into artist (first_name, last_name, country, date_of_birth, date_of_death) values 
	('Second', 'Second', 'Second', '1850-05-02', '1900-05-02');
	
--2. ains_picture_hall

--Let's see
select * from exhibition_hall_painting;
--Can't add in a full exhibition hall
select * from exhibition_hall where id_hall = 1004;
insert into exhibition_hall_painting (id_painting, id_exhibition, id_hall) values (100002,1004,1004);
	
--3. ains_orders

--Let's see 
select * from orders;
--Ex1. expired card
select* from payment where  cardno = '301771555836';
insert into orders (cardNo, id_cart, ord_date) values ('301771555836', 10, '2021-06-13');
select * from orders;

--Ex2. low balance
select* from payment where  cardno = '355580774073';
insert into orders (cardNo, id_cart, ord_date) values ('355580774073', 4, '2021-06-13');
select * from orders;

--Ex3 succesfull order
select* from payment where  cardno = '355580774073';
insert into orders (cardNo, id_cart, ord_date) values ('355580774073', 10, '2021-06-13');
select * from orders;

--4. bins_orders
select * from orders ;
select * from payment;
insert into orders (cardNo, id_cart, ord_date) values ('304596354637', 4, '2020-08-13');

--5. ains_painting_shoppingcart
select * from painting_shoppingcart;
select * from shopping_cart where id_cart = 5;
insert into painting_shoppingcart(id_painting, id_cart) values (100004,5);

--6. adel_painting_shoppingcar

select * from painting_shoppingcart;
delete from painting_shoppingcart where id = 8;
select * from shopping_cart where id_cart = 5;

--Views

--1. v_order_products
select * from v_order_products;

--2. v_paintings_price_category;
select * from v_paintings_price_category;

--3. v_paintings_lower_price
select * from v_paintings_lower_price;

--4. v_artist_top_painting
select * from v_artist_top_painting;

--5. v_paintings_price_stat
select * from v_paintings_price_stat;

--6. v_artist_num_paintings_stat
select * from v_artist_num_paintings_stat;

--7. v_succesful_orders_info
select * from v_succesful_orders_info;