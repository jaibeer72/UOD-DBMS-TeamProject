-- Active: 1666018643741@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@DilveryDatabase
CREATE DATABASE DilveryDatabase;

use DilveryDatabase; 

CREATE TABLE resteraunts(
    resteraunt_id INT auto_increment, 
    resteraunt_name VARCHAR(20), 
    cuisine VARCHAR (20), 
    resteraunt_pricefactor INT,
    PRIMARY KEY (resteraunt_id)
);


INSERT INTO resteraunts (resteraunt_name,cuisine , resteraunt_pricefactor) VALUES("ABBAS RESTERAUNT", "Chinese", 2);

SELECT * FROM resteraunts; 
