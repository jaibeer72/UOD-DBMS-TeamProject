-- Active: 1666003760240@@Jaibeers-MBP.wireless.dundee.ac.uk@3306@22ac5d04

INSERT INTO
    restaurants (
        restaurants.restaurant_name,
        restaurants.restaurant_city,
        restaurants.cuisine,
        restaurants.restaurant_description,
        restaurants.restaurent_userid
    )
VALUES
(
        "Rancho Rancho",
        "Dundee",
        "Mexican",
        "combines the techniques and style of the Mexican city,her delicious award-winning dishes, sumptuous cocktails,",
        "RanchoRanchoDundee"
    );


INSERT INTO
    restaurants (
        restaurants.restaurant_name,
        restaurants.restaurant_city,
        restaurants.cuisine,
        restaurants.restaurant_description,
        restaurants.restaurent_userid
    )
VALUES
(
        "Gidi Grills",
        "Dundee",
        "Caribbean",
        "Gidi Grills brings Scotland the vibrant, flavorful, and powerful flavors of West Africa and the Caribbean.",
        "GidiGrillsDundee"
    );

    INSERT INTO
    restaurants (
        restaurants.restaurant_name,
        restaurants.restaurant_city,
        restaurants.cuisine,
        restaurants.restaurant_description,
        restaurants.restaurent_userid
    )
VALUES
(
        "THE NIBLICK",
        "Dundee",
        "vegan",
        "They serve Breakfast and Lunch including vegan and vegetarian dishes.",
        "TheNiblickDundee"
    );

-- food table insertion for RanchoRancho

INSERT INTO
foodList(
    foodLIST.food_name,
    foodLIST.food_price,
    foodLIST.food_description,
    foodLIST.food_status,
    foodList.restaurant_id
)
VALUES(
    "Loaded Potato Skins ",
    6.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
);

INSERT INTO
foodList(
    foodLIST.food_name,
    foodLIST.food_price,
    foodLIST.food_description,
    foodLIST.food_status,
    foodList.restaurant_id
)
VALUES(
    "Nachos Grande",
    6.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "jalapos",
    6.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Wings of Fire",
    6.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Chicken, Chorizo Stir-fry",
    6.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Mozza Melts",
    6.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
)
;

INSERT INTO
foodList(
    foodLIST.food_name,
    foodLIST.food_price,
    foodLIST.food_description,
    foodLIST.food_status,
    foodList.restaurant_id
)
VALUES
(
    "Chicken & Chorizo Tacos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Picadillo Tacos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Beef Verde Tacos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Bean Tacos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Chipotle Chicken Burritos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Picadillo Burritos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Beef Burritos",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Quesadillas Chicken Chorizo",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Quesadillas Beef Verde",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
),
(
    "Quesadillas Cajun Prawn",
    13.95,
    "description",
    true,
    (SELECT restaurant_id FROM restaurants WHERE restaurent_userid = "RanchoRanchoDundee")
)
;

