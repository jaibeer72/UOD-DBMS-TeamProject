-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04

INSERT INTO
    deliveryExecutive(
        deliveryExecutive.driver_userId,
        deliveryExecutive.driver_name,
        deliveryExecutive.driver_location,
        deliveryExecutive.driver_contact,
        deliveryExecutive.driver_status
    )
VALUES (
        "TestDriver1",
        "Test Driver",
        "Dundee",
        41492,
        true
    );
    


CREATE OR REPLACE VIEW DRIVERVIEW AS
SELECT
    orders.order_id,
    orders.order_code,
    orders.customer_id,
    orders.restaurant_id,
    orders.order_data_time,
    orders.delivery_charge,
    orders.order_status,
    orders.driver_id,
    deliveryExecutive.driver_location,
    deliveryExecutive.driver_status
FROM orders
    LEFT JOIN deliveryExecutive ON deliveryExecutive.driver_id = orders.driver_id;

SELECT * FROM DRIVERVIEW;
-- Make Driver Available 
-- Make Driver Unavailable 
-- View available orders to accept

SELECT 
    (SELECT customer.customer_address FROM customer WHERE customer.customer_id = DRIVERVIEW.customer_id) AS CustomerAddress,
    (SELECT restaurants.restaurant_address FROM restaurants WHERE restaurants.restaurant_id = DRIVERVIEW.restaurant_id) As RestaurantAddress,
    DRIVERVIEW.delivery_charge,
    DRIVERVIEW.order_id
    FROM DRIVERVIEW
    WHERE DRIVERVIEW.order_status = "Requested" OR DRIVERVIEW.order_status = "Ready-To-PickUp";


-- Accept Order 
-- Mark Order as picked up 
-- Mark order as delivered
-- See total earnings 
-- See past and Current orders