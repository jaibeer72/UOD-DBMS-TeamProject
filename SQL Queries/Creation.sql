-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04

USE 22ac5d04;

CREATE TABLE `customer`(
    `customer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `customer_name` VARCHAR(255) NOT NULL,
    `customer_city` ENUM('Dundee','London','Glasgow') NOT NULL,
    `customer_email` VARCHAR(255) NOT NULL,
    `customer_userId` VARCHAR(255) NOT NULL,
    `customer_password` VARCHAR(255) NOT NULL
);

CREATE TABLE `deliveryExecutive`(
    `driver_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `driver_name` VARCHAR(255) NOT NULL,
    `driver_location` VARCHAR(255) NOT NULL,
    `driver_contact` INT NOT NULL,
    `driver_status` TINYINT(1) NOT NULL
);

CREATE TABLE `foodList`(
    `food_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT NOT NULL,
    `food_name` VARCHAR(255) NOT NULL,
    `food_price` DOUBLE(4, 2) NOT NULL,
    `food_description` VARCHAR(255) NOT NULL,
    `food_status` TINYINT(1) NOT NULL
);

CREATE TABLE `orders`(
    `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_code` INT UNSIGNED NOT NULL,
    `customer_id` INT UNSIGNED NOT NULL,
    `order_data_time` DATETIME NOT NULL,
    `restaurant_id` INT UNSIGNED NOT NULL,
    `food_price` DOUBLE(8, 2) NOT NULL,
    `delivery_charge` DOUBLE(8, 2) NOT NULL,
    `order_status` ENUM('In-cart','Requested','Accepted-By-Resteraunt','Executive-Assigned','Ready-To-PickUp','Picked-Up','Delivered') NOT NULL DEFAULT 'In-cart',
    `driver_id` INT UNSIGNED NULL,
    `commission_charges` INT UNSIGNED NOT NULL,
    `recipe_id` INT NULL
);

CREATE TABLE `reviews`(
    `review_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT UNSIGNED NOT NULL,
    `customer_id` INT UNSIGNED NOT NULL,
    `review` VARCHAR(255) NOT NULL,
    `rating` INT UNSIGNED NOT NULL
);

CREATE TABLE `restaurants`(
    `restaurant_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_name` CHAR(255) NOT NULL,
    `restaurant_city` ENUM('Dundee','London','Glasgow') NOT NULL,
    `restaurent_user` VARCHAR(255) NOT NULL,
    `restaurant_password` VARCHAR(255) NOT NULL
);

CREATE TABLE `SupportPersonal`(
    `staff_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `staff_compensation` DOUBLE(8, 2) NOT NULL,
    `is_available` TINYINT(1) NOT NULL,
    `hq_supervisor` INT NOT NULL,
    `staff_location` VARCHAR(255) NOT NULL
);

CREATE TABLE `supportTickets`(
    `ticket_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ticket_status` ENUM('open','Waiting-On-Customer','Waiting-On-Support','Resolved') NOT NULL,
    `assignee` INT NOT NULL,
    `order_id` INT NOT NULL
);

CREATE TABLE `hq_staff`(
    `hq_staff_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `hq_staff_position` ENUM('CEO','CFO','Support-Supervisor','IT-Admin') NOT NULL,
    `hq_staff_location` VARCHAR(255) NOT NULL
);

CREATE TABLE `payments`(
    `recipt_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `payment_type` ENUM('Cash','Card') NOT NULL,
    `gateway_recipt_serial` INT UNSIGNED NULL,
    `payment_status` ENUM('Not-Paid','Paid') NOT NULL,
    `payment_date_time` DATETIME NOT NULL
);

CREATE TABLE `sales`(
    `sales_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT UNSIGNED NOT NULL,
    `completed_count` INT UNSIGNED NOT NULL,
    `refunded_count` INT UNSIGNED NOT NULL,
    `cancelled_count` INT UNSIGNED NOT NULL,
    `total_comission` DOUBLE(8, 2) NOT NULL,
    `total_compensation` DOUBLE(8, 2) NOT NULL,
    `total_delivery_charges` DOUBLE(8, 2) NOT NULL
);

CREATE TABLE `sales_hq_staff`(
    `sales_hq_staff_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT NOT NULL,
    `hq_staff_id` INT NOT NULL
);


CREATE TABLE `OrdersFoodItem`(
    `Order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Food_id` INT UNSIGNED NOT NULL,
    `Quantity` INT UNSIGNED NOT NULL
);

ALTER TABLE
    `OrdersFoodItem` ADD CONSTRAINT `ordersfooditem_food_id_foreign` FOREIGN KEY(`Food_id`) REFERENCES `foodList`(`food_id`) ON DELETE SET NULL;

-- Food list forign keys
ALTER TABLE
    `foodList` ADD CONSTRAINT `foodlist_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE; -- on delte we need to delte all the food items 

-- Reviews forign keys
ALTER TABLE
    `reviews` ADD CONSTRAINT `reviews_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE CASCADE; -- on delte No reviews required
ALTER TABLE
    `reviews` ADD CONSTRAINT `reviews_customer_id_foreign` FOREIGN KEY(`customer_id`) REFERENCES `customer`(`customer_id`) ON DELETE CASCADE; -- on delte No reviews required

-- Orders table forign keys
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY(`customer_id`) REFERENCES `customer`(`customer_id`) ON DELETE SET NULL;
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE SET NULL;
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_driver_id_foreign` FOREIGN KEY(`driver_id`) REFERENCES `deliveryExecutive`(`driver_id`) ON DELETE SET NULL;
ALTER TABLE
    `orders` ADD CONSTRAINT `orders_recipe_id_foreign` FOREIGN KEY(`recipe_id`) REFERENCES `payments`(`recipt_id`); -- Immutable on sucess

-- support tickes forign keys
ALTER TABLE
    `supportTickets` ADD CONSTRAINT `supporttickets_assignee_foreign` FOREIGN KEY(`assignee`) REFERENCES `SupportPersonal`(`staff_id`)  ON DELETE SET NULL;
ALTER TABLE
    `supportTickets` ADD CONSTRAINT `supporttickets_order_id_foreign` FOREIGN KEY(`order_id`) REFERENCES `orders`(`order_id`)  ON DELETE SET NULL;

-- support personal forign keys
ALTER TABLE
    `SupportPersonal` ADD CONSTRAINT `supportpersonal_hq_supervisor_foreign` FOREIGN KEY(`hq_supervisor`) REFERENCES `hq_staff`(`hq_staff_id`)  ON DELETE SET NULL;

-- TODO look into this later if this is needed over time
ALTER TABLE
    `sales_hq_staff` ADD CONSTRAINT `sales_hq_staff_hq_staff_id_foreign` FOREIGN KEY(`hq_staff_id`) REFERENCES `hq_staff`(`hq_staff_id`)  ON DELETE SET NULL;
ALTER TABLE
    `sales` ADD CONSTRAINT `sales_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`)  ON DELETE SET NULL; -- need to maintain total sales even if the resteraunt is gone. 