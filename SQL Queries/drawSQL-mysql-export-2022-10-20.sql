CREATE TABLE `customerTable`(
    `customer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `customer_name` VARCHAR(255) NOT NULL,
    `customer_city` VARCHAR(255) NOT NULL,
    `customer_email` VARCHAR(255) NOT NULL,
    `customer_userId` VARCHAR(255) NOT NULL,
    `customer_password` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `customerTable` ADD PRIMARY KEY `customertable_customer_id_primary`(`customer_id`);
CREATE TABLE `deliveryPartnerTable`(
    `driver_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `driver_name` VARCHAR(255) NOT NULL,
    `driver_location` VARCHAR(255) NOT NULL,
    `driver_contact` INT NOT NULL,
    `driver_status` TINYINT(1) NOT NULL
);
ALTER TABLE
    `deliveryPartnerTable` ADD PRIMARY KEY `deliverypartnertable_driver_id_primary`(`driver_id`);
CREATE TABLE `foodListTable`(
    `food_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `restaurant_id` INT NOT NULL,
    `food_name` VARCHAR(255) NOT NULL,
    `food_price` DOUBLE(8, 2) NOT NULL,
    `food_description` VARCHAR(255) NOT NULL,
    `food_status` TINYINT(1) NOT NULL
);
ALTER TABLE
    `foodListTable` ADD PRIMARY KEY `foodlisttable_food_id_primary`(`food_id`);
CREATE TABLE `ordersTable`(
    `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_code` INT NOT NULL,
    `customer_id` INT NOT NULL,
    `order_data_time` DATETIME NOT NULL,
    `food_id` INT NOT NULL,
    `restaurant_id` INT NOT NULL,
    `food_price` DOUBLE(8, 2) NOT NULL,
    `delivery_charge` DOUBLE(8, 2) NOT NULL,
    `order_status` INT NOT NULL,
    `driver_id` INT NULL
);
ALTER TABLE
    `ordersTable` ADD PRIMARY KEY `orderstable_order_id_primary`(`order_id`);
CREATE TABLE `adminUsersTable`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT
);
ALTER TABLE
    `adminUsersTable` ADD PRIMARY KEY `adminuserstable_id_primary`(`id`);
CREATE TABLE `restaurantsTable`(
    `restaurant_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `restaurant_name` CHAR(255) NOT NULL,
    `restaurant_city` VARCHAR(255) NOT NULL,
    `restaurent_user` VARCHAR(255) NOT NULL,
    `restaurant_password` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `restaurantsTable` ADD PRIMARY KEY `restaurantstable_restaurant_id_primary`(`restaurant_id`);
ALTER TABLE
    `foodListTable` ADD CONSTRAINT `foodlisttable_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurantsTable`(`restaurant_id`);
ALTER TABLE
    `ordersTable` ADD CONSTRAINT `orderstable_customer_id_foreign` FOREIGN KEY(`customer_id`) REFERENCES `customerTable`(`customer_id`);
ALTER TABLE
    `ordersTable` ADD CONSTRAINT `orderstable_food_id_foreign` FOREIGN KEY(`food_id`) REFERENCES `foodListTable`(`food_id`);
ALTER TABLE
    `ordersTable` ADD CONSTRAINT `orderstable_restaurant_id_foreign` FOREIGN KEY(`restaurant_id`) REFERENCES `restaurantsTable`(`restaurant_id`);
ALTER TABLE
    `ordersTable` ADD CONSTRAINT `orderstable_driver_id_foreign` FOREIGN KEY(`driver_id`) REFERENCES `deliveryPartnerTable`(`driver_id`);