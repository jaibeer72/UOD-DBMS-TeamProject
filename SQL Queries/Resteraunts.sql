-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04

-- Create resteraunt view to see foodlist

CREATE OR REPLACE VIEW RESTAURANTFOODVIEW AS 
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
	    CROSS JOIN foodList ON restaurants.restaurant_id = foodList.r
RESTAURANT_ID; 

SELECT * FROM RestaurantFoodView;

CREATE OR REPLACE VIEW RESTAURANTORDERVIEW AS 
	SELECT
	    orders.order_id,
	    orders.order_code,
	    orders.customer_id,
	    orders.restaurant_id,
	    orders.order_data_time,
	    orders.food_price AS TotalOrderPrice,
	    orders.commission_charges,
	    orders.order_status,
	    OrdersFoodItem.Food_id,
	    OrdersFoodItem.Quantity,
	    foodList.food_name,
	    foodList.food_price,
	    foodList.food_description
	FROM orders
	    CROSS JOIN OrdersFoodItem ON OrdersFoodItem.order_id = orders.order_id
	    CROSS JOIN foodList ON foodList.food_id = OrdersFoodItem.FOOD_ID; 

SELECT * FROM RestaurantOrderView;

-- Current ordered available to accept

DELIMITER //

CREATE PROCEDURE GETORDERSAVAILABLETOACCEPT(IN RESID 
INT UNSIGNED) BEGIN 
	SELECT
	    RestaurantOrderView.order_id,
	    RestaurantOrderView.order_code,
	    RestaurantOrderView.food_price AS TotalOrderPrice,
	    RestaurantOrderView.commission_charges,
	    RestaurantOrderView.order_status,
	    RestaurantOrderView.food_name,
	    RestaurantOrderView.Quantity
	FROM RestaurantOrderView
	WHERE
	    RestaurantOrderView.restaurant_id = RESID
	    AND RestaurantOrderView.order_status = "Requested"
	ORDER BY
	    RestaurantOrderView.order_id ASC;
	END 


DELIMITER;

CALL GetOrdersAvailableToAccept(1);

-- all older orders

DELIMITER //

CREATE PROCEDURE GETREST_ORDERHISTORY(IN RESID INT 
UNSIGNED) BEGIN 
	SELECT
	    DISTINCT RestaurantOrderView.order_id,
	    RestaurantOrderView.TotalOrderPrice,
	    RestaurantOrderView.commission_charges,
	    RestaurantOrderView.order_data_time,
	    RestaurantOrderView.order_status
	FROM
	    RestaurantOrderView
	WHERE
	    RestaurantOrderView.restaurant_id = RESID
	    AND (
	        RestaurantOrderView.order_status = "Requested"
	        OR RestaurantOrderView.order_status = "Accepted-By-Resteraunt"
	        OR RestaurantOrderView.order_status = "Executive-Assigned"
	        OR RestaurantOrderView.order_status = "Ready-To-PickUp"
	        OR RestaurantOrderView.order_status = "Picked-Up"
	        OR RestaurantOrderView.order_status = "Delivered"
	    )
	ORDER BY
	    RestaurantOrderView.order_data_time DESC;
END; 

DELIMITER;

CALL GetRest_OrderHistory(1);

-- make food items unavailable


DELIMITER //
CREATE PROCEDURE SETREST_REMOVEFROM_MENU(IN foodID INT 
UNSIGNED) BEGIN 
    UPDATE RESTAURANTFOODVIEW
    SET RESTAURANTFOODVIEW.food_status = false
    WHERE RESTAURANTFOODVIEW.food_id = foodID;
END; 
DELIMITER;

CALL SETREST_REMOVEFROM_MENU(6);

DELIMITER //
CREATE PROCEDURE SETREST_ADDTOMENU_MENU(IN foodID INT 
UNSIGNED) BEGIN 
    UPDATE RESTAURANTFOODVIEW
    SET RESTAURANTFOODVIEW.food_status = true
    WHERE RESTAURANTFOODVIEW.food_id = foodID;
END; 
DELIMITER;

CALL SETREST_ADDTOMENU_MENU(6);

-- ACCEPT an Order

DELIMITER //

CREATE PROCEDURE SETREST_ACCEPTORDER(IN ORDERID INT 
UNSIGNED) BEGIN 

    DECLARE m_FoodStatus VARCHAR(225);
	START TRANSACTION;

	SELECT DISTINCT
	    RestaurantOrderView.order_status INTO m_FoodStatus
        FROM RestaurantOrderView
	WHERE
	    RestaurantOrderView.order_id = orderID;

	IF (m_FoodStatus = "Requested") THEN
	UPDATE RestaurantOrderView
	SET
	    RestaurantOrderView.order_status = "Accepted-By-Resteraunt"
	WHERE
	    RestaurantOrderView.order_id = orderID;
	COMMIT;
	ELSE ROLLBACK;
	END IF;
END; 

DELIMITER;

CALL SETREST_ACCEPTORDER(2);

-- Reject an order

DELIMITER //

CREATE PROCEDURE SETREST_REJECTORDER(IN ORDERID INT 
UNSIGNED) BEGIN 

    DECLARE m_FoodStatus VARCHAR(225);
	START TRANSACTION;

	SELECT DISTINCT
	    RestaurantOrderView.order_status INTO m_FoodStatus
        FROM RestaurantOrderView
	WHERE
	    RestaurantOrderView.order_id = orderID;

	IF (m_FoodStatus = "Requested") THEN
	UPDATE RestaurantOrderView
	SET
	    RestaurantOrderView.order_status = "Rejected-By-Rest"
	WHERE
	    RestaurantOrderView.order_id = orderID;
	COMMIT;
	ELSE ROLLBACK;
	END IF;
END; 

CALL SETREST_REJECTORDER(2);

DELIMITER //

CREATE PROCEDURE SETREST_ORDER_READYTOPICKUP(IN ORDERID INT 
UNSIGNED) BEGIN 

    DECLARE m_FoodStatus VARCHAR(225);
	START TRANSACTION;

	SELECT DISTINCT
	    RestaurantOrderView.order_status INTO m_FoodStatus
        FROM RestaurantOrderView
	WHERE
	    RestaurantOrderView.order_id = orderID;

	IF (m_FoodStatus = "Accepted-By-Resteraunt" OR m_FoodStatus = "Executive-Assigned") THEN
	UPDATE RestaurantOrderView
	SET
	    RestaurantOrderView.order_status = "Ready-To-PickUp"
	WHERE
	    RestaurantOrderView.order_id = orderID;
	COMMIT;
	ELSE ROLLBACK;
	END IF;
END; 

CALL SETREST_ORDER_READYTOPICKUP(2);
