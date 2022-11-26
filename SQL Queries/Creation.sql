-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04
SHOW DATABASES;

/* Table to hold customer data*/

CREATE TABLE `customer`(
    `customer_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `customer_name` VARCHAR(25) NOT NULL,
    `customer_city` VARCHAR(25) NOT NULL,
    `customer_email` VARCHAR(50) NOT NULL,
    `customer_userId` VARCHAR(25) NOT NULL,
    `customer_password` VARCHAR(255) NOT NULL
);


/*Table deliveryExecutive stores all data about the delivery personnel*/

CREATE TABLE `deliveryExecutive`(
    `driver_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `driver_name` VARCHAR(25) NOT NULL,
    `driver_location` VARCHAR(25) NOT NULL,
    `driver_contact` INT NOT NULL,
    `driver_status` TINYINT(1) NOT NULL /*if is available or not */ 
);


/*Table foodList stores all data about the food items that each restaurant serves*/

CREATE TABLE `foodList`(
    `food_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT NOT NULL,
    `food_name` VARCHAR(20) NOT NULL,
    `food_price` DOUBLE(8, 2) NOT NULL, /*floating point to 2 decimals*/ 
    `food_description` VARCHAR(255),
    `food_status` TINYINT(1) NOT NULL
);



/*Table orders stores all data about orders placed by customers */
/*On delete the forign keys will be set null cause basic order information has to be immutable*/
/*TODO : OnDelete , OnStatus change events create insert domans */
/*TODO : Joining table for order foodItemID*/
CREATE TABLE `orders`(
    `order_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_code` INT  NOT NULL,
    `customer_id` INT  NOT NULL,
    `order_data_time` DATETIME NOT NULL,
    `food_id` INT  NOT NULL,
    `restaurant_id` INT  NOT NULL,
    `food_price` DOUBLE(8, 2) NOT NULL,
    `delivery_charge` DOUBLE(8, 2) NOT NULL,
    `order_status` ENUM('in-cart','requested','accepted-by-rest','ready-to-deliver','out-for-delivery','delivered','compleated') NOT NULL,
    `driver_id` INT  NULL,
    `commission_charges` INT  NOT NULL,
    `recipe_id` INT NULL,
    FOREIGN KEY(`customer_id`) REFERENCES `customer`(`customer_id`) ON DELETE SET NULL,
    FOREIGN KEY(`food_id`) REFERENCES `foodList`(`food_id`) ON DELETE SET NULL, -- need to add a joining table for this 
	FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`) ON DELETE SET NULL,
	FOREIGN KEY(`driver_id`) REFERENCES `deliveryExecutive`(`driver_id`)ON DELETE SET NULL,
	FOREIGN KEY(`recipe_id`) REFERENCES `payments`(`recipt_id`) ON DELETE SET NULL
);


/*Table reviews stores all data about the food items that each restaurant serves*/

CREATE TABLE `reviews`(
    `review_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT  NOT NULL,
    `customer_id` INT  NOT NULL,
    `review` VARCHAR(255) NOT NULL,
    `rating` INT CHECK ( `rating` >= 0 AND `rating` <=5)  NOT NULL /*keep the rating between 0-5*/ 
    FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`),
	FOREIGN KEY(`customer_id`) REFERENCES `customer`(`customer_id`)
);

/*Table restaurants stores all data about the different restaurants available*/

CREATE TABLE `restaurants`(
    `restaurant_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_name` CHAR(255) NOT NULL,
    `restaurant_city` VARCHAR(255) NOT NULL,
    `restaurent_user` VARCHAR(255) NOT NULL,
    `restaurant_password` VARCHAR(255) NOT NULL,
    `rating` INT CHECK ( `rating` >= 0 AND `rating` <=5)  NOT NULL
);

/*Table SupportPersonnel stores all data about support personnel that manages operations at a restaurant*/

CREATE TABLE `SupportPersonnel`(
    `staff_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `staff_compensation` DOUBLE(8, 2) NOT NULL,
    `is_available` TINYINT(1) NOT NULL,
    `hq_supervisor` INT NOT NULL,
    `staff_location` VARCHAR(255) NOT NULL,
    FOREIGN KEY(`hq_supervisor`) REFERENCES `hq_staff`(`hq_staff_id`)
);



CREATE TABLE `supportTickets`(
    `ticket_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ticket_status` ENUM('Pending', 'Resolved','waiting on customer','open') NOT NULL,
    `assignee` INT NOT NULL,
    `order_id` INT NOT NULL,
    FOREIGN KEY(`assignee`) REFERENCES `SupportPersonnel`(`staff_id`),
    FOREIGN KEY(`order_id`) REFERENCES `orders`(`order_id`)
);


CREATE TABLE `hq_staff`(
    `hq_staff_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `hq_staff_position` ENUM('Executive', 'Regional Support Manager') NOT NULL,
    `hq_staff_location` VARCHAR(255) NOT NULL
);

/*Table payment stores all payment data*/

CREATE TABLE `payments`(
    `recipt_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `payment_type` ENUM('Card', 'Cash on Delivery') NOT NULL,
    `gateway_recipt_serial` INT  NULL,
    `payment_status` ENUM('Pending', 'Successful', 'Failed') NOT NULL,
    `payment_date_time` DATETIME NOT NULL
);




/*Table sales stores all data about sales made*/

CREATE TABLE `sales`(
    `sales_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT  NOT NULL,
    `completed_count` INT  NOT NULL,
    `refunded_count` INT  NOT NULL,
    `cancelled_count` INT  NOT NULL,
    `total_comission` DOUBLE(8, 2) NOT NULL,
    `total_compensation` DOUBLE(8, 2) NOT NULL,
    `total_delivery_charges` DOUBLE(8, 2) NOT NULL,
    FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`)
);



CREATE TABLE `sales_hq_staff`(
    `sales_hq_staff_id` INT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `restaurant_id` INT NOT NULL,
    `hq_staff_id` INT NOT NULL,
    FOREIGN KEY(`hq_staff_id`) REFERENCES `hq_staff`(`hq_staff_id`)
);



/*This constraint below was included separately because the foodlist table was created before we decided to include the foreign key*/

ALTER TABLE
    `foodList` ADD CONSTRAINT `foodlist_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurants`(`restaurant_id`);
