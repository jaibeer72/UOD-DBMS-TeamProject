-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04

-- Create new resteraunt 



-- Add food item 1 




-- add multiple food items at once ? i don't know if that's possible if not let's create a new fild for insertions 




-- Create resteraunt view to see foodlist
CREATE VIEW Restuarant_food AS
    (SELECT 
        r.restaurant_id,
        restaurant_name,
        restaurant_city,
        food_name,
        food_price,
        food_description,
        food_status
    FROM restaurants
    JOIN foodlist
    ON r.restaurant_id = foodlist. restaurant_id
    );



-- Current ordered available to accept




-- all older orders




-- add food items




-- make food items unavailable




-- delete food items.
