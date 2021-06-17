--Stored procedures

--1. Log all failed orders in a log table
CREATE OR REPLACE PROCEDURE proc_log_failed_orders()
LANGUAGE plpgsql
AS $$
DECLARE 
	declined_info CHAR(40);
	exp_date DATE;
	curr_balance NUMERIC(15,2);
	row orders%rowtype;
BEGIN
	FOR row IN  SELECT * FROM fnc_unlogged_orders() LOOP
		
		SELECT fnc_get_exp_date_card(row.cardNo)
		INTO exp_date;
		
		SELECT fnc_get_balance_card(row.cardNo)
		INTO curr_balance;	
		
		IF (row.ord_date > exp_date) THEN
				INSERT INTO log_table_declined_orders (id_order, log_info) VALUES (row.id_order, N'expired card');	
		ELSE
				INSERT INTO log_table_declined_orders (id_order, log_info) VALUES (row.id_order, N'low card balance');
		END IF;
	END LOOP;
END;$$