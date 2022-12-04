-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04

-- Create new customer

INSERT INTO
    customer(
        customer.customer_name,
        customer.customer_city,
        customer.customer_email,
        customer.customer_userId
    )
VALUES (
        "Jaibeer",
        "Dundee",
        "jaibeer2test@gmail.com",
        "jaibeer2"
    );

-- Get Customer information

SELECT * from customer WHERE customer.customer_name = "Jaibeer";

-- Update information

-- Delete

-- Create Customer view for resteraunts based on the city of the customer

CREATE OR REPLACE VIEW CUSTOMERALLRESTERAUNTS AS 
	SELECT
	    restaurants.restaurant_id,
	    restaurants.restaurant_name,
	    restaurants.restaurant_city,
	    restaurants.cuisine,
	    restaurants.restaurant_description,
	    foodList.food_id,
	    foodList.food_name,
	    foodList.food_price,
	    foodList.food_description,
	    foodList.food_status
	FROM restaurants
	    CROSS JOIN foodList ON restaurants.restaurant_id = foodList.R
RESTAURANT_ID; 

SELECT * FROM customerallresteraunts;

-- Created procedure to make sure we don't need to make the table again and again

DELIMITER //

CREATE PROCEDURE GETCURRENTCITYRESTARAUNTS(IN CITY 
VARCHAR(255)) BEGIN 
	SELECT
	    DISTINCT customerallresteraunts.restaurant_name,
	    customerallresteraunts.cuisine,
	    customerallresteraunts.restaurant_description
	FROM customerallresteraunts
	WHERE
	    customerallresteraunts.restaurant_city = city;
END; 

DELIMITER;

CALL GetCurrentCityRestaraunts("Dundee");

-- Create Customer Table for selected resteratunts

DELIMITER //

CREATE PROCEDURE GETSELECTEDRESTERAUNT(IN ID INT UNSIGNED
) BEGIN 
	SELECT
	    food_id,
	    food_name,
	    food_price,
	    food_description,
	    food_status
	FROM customerallresteraunts
	WHERE
	    customerallresteraunts.restaurant_id = ID;
	END 


DELIMITER;

CALL GetSelectedResteraunt(0);

-- Customer create new order

-- Customer Check out

-- Customer see previous orders

DELIMITER //

CREATE PROCEDURE GETCUSTOMERORDERHISTORY(IN ID INT 
UNSIGNED) BEGIN 
	SELECT
	    orders.order_id,
	    orders.order_data_time,
	    orders.restaurant_id,
	    orders.food_price,
	    orders.delivery_charge,
	    orders.order_status,
	    restaurants.restaurant_id,
	    restaurants.restaurant_name,
	    restaurants.restaurant_city
	FROM orders
	    CROSS JOIN restaurants ON orders.restaurant_id = restaurants.restaurant_id AND orders.customer_id = id
	ORDER BY
	    orders.order_data_time DESC;
	END 


DELIMITER;

CALL GetCustomerOrderHistory(0);

-- See Resteraunt menu.

DELIMITER //

CREATE PROCEDURE GETRESTERAUNTMENU(IN RESNAME VARCHAR
(255)) BEGIN 
	SELECT
	    foodList.food_id,
	    foodList.food_name,
	    foodList.restaurant_id,
	    foodList.food_price,
	    foodList.food_description
	FROM foodList
	Where (
	        SELECT restaurant_id
	        FROM restaurants
	        WHERE
	            restaurant_name = resName
	    ) = foodList.restaurant_id
	    AND foodList.food_status = true;
	END 


DELIMITER;

CALL GetResterauntMenu("Rancho Rancho");

DELIMITER// 

CREATE FUNCTION GETTOTALFOODPRICE(ORDERID INT) RETURNS 
DOUBLE DETERMINISTIC BEGIN 
	DECLARE total DOUBLE;
	SELECT
	    SUM(foodList.food_price) INTO total
	FROM foodList
	WHERE foodList.food_id IN (
	        SELECT
	            OrdersFoodItem.Food_id
	        FROM OrdersFoodItem
	        WHERE
	            OrdersFoodItem.Order_id = orderID
	    );
	RETURN total;
	END 

DELIMITER; 


SELECT GETTOTALFOODPRICE(2);

DELIMITER //

CREATE PROCEDURE ADDFOODITEMTOORDER(IN FOODID INT, 
IN QUANT INT, IN CUSTOMERID INT) BEGIN 
	DECLARE curorder INT DEFAULT 0;
	DECLARE TotalPriceVal DOUBLE;
	DECLARE resterauntID INT DEFAULT 0;
	START TRANSACTION;
	SELECT
	    foodList.restaurant_id into resterauntID
	FROM foodList
	WHERE
	    foodList.food_id = foodID;
	SELECT
	    orders.order_id into curorder
	FROM orders
	WHERE
	    orders.customer_id = customerID
	    AND order_status = 'In-cart';
	IF curorder > 0 THEN -- if the resterauntid matches the one in a current order
	IF (
	    SELECT
	        foodList.restaurant_id
	    FROM foodList
	    WHERE
	        foodList.food_id = foodID
	) = (
	    SELECT
	        orders.restaurant_id
	    FROM orders
	    WHERE
	        orders.order_id = curorder
	) THEN -- Add to Order
	-- if FoodItem Exists
	IF (
	    SELECT
	        COUNT(OrdersFoodItem.Food_id)
	    FROM OrdersFoodItem
	    WHERE
	        OrdersFoodItem.Order_id = curorder
	        and OrdersFoodItem.Food_id = foodID
	) = 1 THEN -- update food quantity 
	UPDATE OrdersFoodItem
	SET
	    OrdersFoodItem.Quantity = quant
	WHERE
	    OrdersFoodItem.Order_id = curorder
	    AND OrdersFoodItem.Food_id = foodID;
	UPDATE orders
	SET
	    orders.food_price = GETTOTALFOODPRICE(curorder)
	WHERE
	    orders.order_id = curorder;
	--else add to food order table and update food order table.
	ELSE
	INSERT INTO
	    OrdersFoodItem(Order_id, Food_id, Quantity)
	VALUES (curOrder, foodID, quant);
	UPDATE orders
	SET
	    orders.food_price = GETTOTALFOODPRICE(curorder)
	WHERE
	    orders.order_id = curorder;
	END IF;
	ELSE -- Delete order and create new order.
	ROLLBACK;
	END IF;
	ELSE -- Insert new order entry 
	-- Insert a new entry into orders table 
	INSERT INTO
	    orders (
	        orders.order_code,
	        orders.customer_id,
	        orders.order_data_time,
	        orders.restaurant_id,
	        food_price,
	        delivery_charge,
	        order_status
	    )
	VALUES ( (
	            FLOOR(RAND() * (999999 -100000 + 1)) + 100000 -- randome 6 digit number
	        ),
	        customerID,
	        NOW(),
	        resterauntID,
	        0.00,
	        2.00,
	        "In-Cart"
	    );
	SELECT LAST_INSERT_ID() INTO curorder;
	INSERT INTO
	    OrdersFoodItem(Order_id, Food_id, Quantity)
	VALUES (curorder, foodID, quant);
	UPDATE orders
	SET
	    orders.food_price = GETTOTALFOODPRICE(curorder)
	WHERE
	    orders.order_id = curorder;
	END IF;
	COMMIT;
END; 

DELIMITER;

CALL ADDFOODITEMTOORDER(1,2,1);

CALL ADDFOODITEMTOORDER(3,2,1);
