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
	    CROSS JOIN foodList ON restaurants.restaurant_id = foodList.RESTAURANT_ID; 

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

CALL GetSelectedResteraunt(1);

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

CALL GetCustomerOrderHistory(1);

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
	SELECT SUM(foodList.food_price * OrdersFoodItem.Quantity) INTO total
	FROM foodList
	CROSS JOIN OrdersFoodItem ON OrdersFoodItem.food_id = foodList.food_id
	WHERE foodList.food_id IN (
	        SELECT
	            OrdersFoodItem.Food_id
	        FROM OrdersFoodItem
	        WHERE
	            OrdersFoodItem.Order_id = ORDERID
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

-- View Cart

DELIMITER// 
CREATE PROCEDURE ViewCart(IN CustomerID INT) BEGIN

DECLARE m_OrderID INT;

SELECT 
   orders.order_id INTO m_OrderID
FROM orders
WHERE
    orders.customer_id = CustomerID AND orders.order_status = "In-cart";

SELECT 
		foodList.food_id,
	    foodList.food_name,
	    foodList.restaurant_id,
	    foodList.food_price,
		OrdersFoodItem.Quantity,
		(foodList.food_price * OrdersFoodItem.Quantity) AS Price
		FROM foodList
			CROSS JOIN OrdersFoodItem ON OrdersFoodItem.Food_id = foodList.food_id
		WHERE OrdersFoodItem.Order_id = m_OrderID;

END;
DELIMITER;

call ViewCart(1);
-- Checkout

-- Get orderID for cart
-- check payments sucess or fail
-- turn order to requested

DELIMITER// 
CREATE PROCEDURE Checkout(IN CustomerID INT, IN PaymentType VARCHAR(255),IN isSucessFull BOOL) BEGIN

DECLARE m_OrderID INT;
DECLARE m_ReciptID INT; 

START TRANSACTION;

SELECT orders.order_id INTO m_OrderID
FROM orders
WHERE orders.customer_id=CustomerID AND orders.order_status = "In-cart";

-- Generate recipt

IF isSucessFull THEN
INSERT INTO payments(
	payments.payment_type,
	payments.gateway_recipt_serial,
	payment_status,
	payment_date_time
)
VALUES(
	PaymentType,
	(
	    FLOOR(RAND() * (9999999 -100000 + 1)) + 100000 -- randome serial
	),
	"Paid",
	NOW()
);

SELECT LAST_INSERT_ID() INTO m_ReciptID;

UPDATE orders
SET orders.recipe_id = m_ReciptID , order_status = "Requested"
WHERE orders.order_id = m_OrderID;


ELSE
	ROLLBACK; 
END IF;

COMMIT;
END;
DELIMITER;

CALL Checkout(1,"Card",true);

-- Search by menu item regi
-- Search by resteraunt name
