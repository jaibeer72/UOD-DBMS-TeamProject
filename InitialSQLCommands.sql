#Creating Customer table

CREATE TABLE Customers(
Customer_id INT PRIMARY KEY,
name varchar(50) NOT NULL,
email varchar(50) NOT NULL,
phone varchar(20) NOT NULL UNIQUE
);

#insert dummy values into table customers

INSERT INTO Customers VALUES ('first name', 'firstname@gmail.com', 077608623623)


#Creating table Orders

CREATE TABLE Orders(
Order_id INT PRIMARY KEY,
Customer_id INT,
order_date datetime,
order_status varchar(50)
amount INT,
FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);
