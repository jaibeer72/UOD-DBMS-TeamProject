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
	SELECT *
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
	    food_status
    FROM customerallresteraunts
    WHERE customerallresteraunts.restaurant_id = id; 
    END
DELIMITER;

CALL GetSelectedResteraunt(0);
-- Customer create new order

-- Customer Check out