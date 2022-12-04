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
	    CROSS JOIN foodList ON foodList.food_id = OrdersFoodItem.F
FOOD_ID; 

SELECT *
FROM
    RestaurantOrderView;
    -- Current ordered available to accept
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
    RestaurantOrderView.restaurant_id = 1
    AND RestaurantOrderView.order_status = "Requested"
ORDER BY RestaurantOrderView.order_id ASC;

-- all older orders

-- view orders requested

-- make food items unavailable

-- ACCEPT an Order 

-- Reject an order 
