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

CREATE PROCEDURE GETCURRENTCITYRESTARAUNTS(IN city VARCHAR(255)) BEGIN 
	SELECT DISTINCT
		customerallresteraunts.restaurant_name,
		customerallresteraunts.cuisine,
		customerallresteraunts.restaurant_description
	FROM customerallresteraunts
	WHERE
	    customerallresteraunts.restaurant_city = city;
	END// 
DELIMITER;

CALL GetCurrentCityRestaraunts("Dundee");

-- Create Customer Table for selected resteratunts

DELIMITER //
CREATE PROCEDURE GetSelectedResteraunt(IN id INT UNSIGNED) BEGIN
    SELECT         
        food_id,
	    food_name,
	    food_price,
	    food_description,
	    food_status,
    FROM customerallresteraunts
    WHERE customerallresteraunts.restaurant_id = id; 
    END
DELIMITER;

CALL GetSelectedResteraunt(0);
-- Customer create new order

-- Customer Check out

-- Customer see previous orders 
DELIMITER //
CREATE PROCEDURE GetCustomerOrderHistory(IN id INT UNSIGNED) BEGIN
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
	CROSS JOIN restaurants ON orders.restaurant_id = restaurants.restaurant_id
	AND orders.customer_id = id
	ORDER BY orders.order_data_time DESC;

    END
DELIMITER;

CALL GetCustomerOrderHistory(0);

-- See Resteraunt menu.

DELIMITER //
CREATE PROCEDURE GetResterauntMenu(IN resName VARCHAR(255)) BEGIN

SELECT
foodList.food_id,
foodList.food_name,
foodList.restaurant_id,
foodList.food_price,
foodList.food_description
FROM foodList
Where (SELECT restaurant_id FROM restaurants WHERE restaurant_name = resName) = foodList.restaurant_id AND foodList.food_status = true;
END
DELIMITER;

CALL GetResterauntMenu("Rancho Rancho");


DELIMITER //
CREATE PROCEDURE AddFoodItemToOrder(IN foodID INT , IN quant INT) BEGIN

DECLARE curorder INT DEFAULT 0;
DECLARE resterauntID INT DEFAULT 0; 

SELECT orders.order_id into curorder FROM orders WHERE orders.customer_id = 0 AND order_status ='In-cart';

IF curorder > 0 THEN
	SELECT orders.restaurant_id into resterauntID FROM orders WHERE orders.order_id = curorder;
	IF (SELECT foodList.restaurant_id FROM foodList WHERE foodList.food_id = foodID) = resterauntID; THEN 
		-- Add to Order
		INSERT INTO OrdersFoodItem(OrdersFoodsItem.Order_id,OrdersFoodItem.Food_id,OrdersFoodItem.Quantity)
		VALUES(curorder,foodID,quant);

		UPDATE orders
		SET orders.food_price = (SELECT OrdersFoodItem.Food_id, OrdersFoodItem.Quantity FROM OrdersFooditem)
	ELSE
		-- Delete order and create new order.
	END IF; 
ELSE
	CALL GetCustomerOrderHistory(0);
END IF;

END
DELIMITER;