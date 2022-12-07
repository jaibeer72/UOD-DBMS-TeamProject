-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04
CREATE DATABASE 22ac5d04;
USE 22ac5d04;

CREATE TABLE `customer`(
    `customer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `customer_name` VARCHAR(255) NOT NULL,
    `customer_city` ENUM('Dundee','London','Glasgow') NOT NULL,
    `customer_email` VARCHAR(255) NOT NULL,
    `customer_userId` VARCHAR(255) NOT NULL,
    `customer_address` VARCHAR(255) NOT NULL,
    UNIQUE(`customer_userId`)
);

CREATE TABLE `deliveryExecutive`(
    `driver_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `driver_userId` VARCHAR(25) NOT NULL,
    `driver_name` VARCHAR(255) NOT NULL,
    `driver_location` VARCHAR(255) NOT NULL,
    `driver_contact` INT NOT NULL,
    `driver_status` TINYINT(1) NOT NULL,
    UNIQUE(`driver_userId`)
);

CREATE TABLE `restaurants`(
    `restaurant_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_name` VARCHAR(255) NOT NULL,
    `restaurant_city` ENUM('Dundee','London','Glasgow') NOT NULL,
    `cuisine` ENUM('Mexican','Caribbean','Vegan','Amrican') NOT NULL,
    `restaurant_description` VARCHAR(255) NOT NULL,
    `restaurent_userid` VARCHAR(255) NOT NULL,
    `restaurant_address` VARCHAR(255) NOT NULL,
    UNIQUE(`restaurent_userid`)
);

CREATE TABLE `foodList`(
    `food_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT UNSIGNED NOT NULL,
    `food_name` VARCHAR(255) NOT NULL,
    `food_price` DOUBLE(4, 2) NOT NULL,
    `food_description` VARCHAR(255) NOT NULL,
    `food_status` TINYINT(1) NOT NULL,
    FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE -- on delte we need to delte all the food items 
);

CREATE TABLE `payments`(
    `recipt_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `payment_type` ENUM('Cash','Card') NOT NULL,
    `gateway_recipt_serial` INT UNSIGNED NULL,
    `payment_status` ENUM('Not-Paid','Paid') NOT NULL,
    `payment_date_time` DATETIME NOT NULL
);

CREATE TABLE `orders`(
    `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_code` INT UNSIGNED NOT NULL,
    `customer_id` INT UNSIGNED NULL,
    `order_data_time` DATETIME NOT NULL,
    `restaurant_id` INT UNSIGNED NULL,
    `food_price` DOUBLE(8, 2) NOT NULL,
    `delivery_charge` DOUBLE(8, 2) NOT NULL,
    `order_status` ENUM('In-cart','Requested','Accepted-By-Resteraunt','Executive-Assigned','Ready-To-PickUp','Picked-Up','Delivered','Rejected-By-Rest','Cancled') NOT NULL DEFAULT 'In-cart',
    `driver_id` INT UNSIGNED NULL,
    `commission_charges` DOUBLE AS (`food_price` * 0.1) NOT NULL,
    `recipe_id` INT UNSIGNED NULL,
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`customer_id`) ON DELETE SET NULL,
    FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE SET NULL,
    FOREIGN KEY(`driver_id`) REFERENCES `deliveryExecutive`(`driver_id`) ON DELETE SET NULL,
    FOREIGN KEY(`recipe_id`) REFERENCES `payments`(`recipt_id`) ON UPDATE CASCADE
);

CREATE TABLE `reviews`(
    `review_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT UNSIGNED NOT NULL,
    `customer_id` INT UNSIGNED NOT NULL,
    `review` VARCHAR(255) NOT NULL,
    `rating` INT UNSIGNED NOT NULL,
    FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE, -- on delte No reviews required
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`customer_id`) ON DELETE CASCADE -- on delte No reviews required
);

CREATE TABLE `hq_staff`(
    `hq_staff_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `hq_staff_position` ENUM('CEO','CFO','Support-Supervisor','IT-Admin') NOT NULL,
    `hq_staff_location` VARCHAR(255) NOT NULL
);

CREATE TABLE `SupportPersonal`(
    `staff_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `staff_compensation` DOUBLE(8, 2) NOT NULL,
    `is_available` TINYINT(1) NOT NULL,
    `hq_supervisor` INT UNSIGNED NULL,
    `staff_location` VARCHAR(255) NOT NULL,
    FOREIGN KEY(`hq_supervisor`) REFERENCES `hq_staff`(`hq_staff_id`)  ON DELETE SET NULL
);

CREATE TABLE `supportTickets`(
    `ticket_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ticket_status` ENUM('open','Waiting-On-Customer','Waiting-On-Support','Resolved') NOT NULL,
    `assignee` INT UNSIGNED NULL,
    `order_id` INT UNSIGNED NULL,
    FOREIGN KEY(`assignee`) REFERENCES `SupportPersonal`(`staff_id`)  ON DELETE SET NULL,
    FOREIGN KEY(`order_id`) REFERENCES `orders`(`order_id`)  ON DELETE SET NULL
);

CREATE TABLE `sales`(
    `sales_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT UNSIGNED NULL,
    `completed_count` INT UNSIGNED NOT NULL,
    `refunded_count` INT UNSIGNED NOT NULL,
    `cancelled_count` INT UNSIGNED NOT NULL,
    `total_comission` DOUBLE(8, 2) NOT NULL,
    `total_compensation` DOUBLE(8, 2) NOT NULL,
    `total_delivery_charges` DOUBLE(8, 2) NOT NULL,
    FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`)  ON DELETE SET NULL -- need to maintain total sales even if the resteraunt is gone. 
);

CREATE TABLE `sales_hq_staff`(
    `sales_hq_staff_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `hq_staff_id` INT UNSIGNED NULL,
    FOREIGN KEY(`hq_staff_id`) REFERENCES `hq_staff`(`hq_staff_id`)  ON DELETE SET NULL
);


CREATE TABLE `OrdersFoodItem`(
    `OrdersFoodItem_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Food_id` INT UNSIGNED NULL,
    `Order_id` INT UNSIGNED NULL,
    `Quantity` INT UNSIGNED NOT NULL,
    FOREIGN KEY(`Food_id`) REFERENCES `foodList`(`food_id`) ON DELETE SET NULL,
    FOREIGN KEY(`Order_id`) REFERENCES `orders`(`order_id`) 
);

CREATE TRIGGER CalculateCommision BEFORE INSERT ON orders FOR EACH ROW SET NEW.commission_charges = (NEW.food_price * 0.1);

CREATE TRIGGER CalculateCommisionUpdate BEFORE UPDATE ON orders FOR EACH ROW SET NEW.commission_charges = (NEW.food_price * 0.1);