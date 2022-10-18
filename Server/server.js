require("dotenv").config();

const express = require("express");
const app = express();

const port = process.env.PORT || 3001;

// Get all resteraunts 
app.get("/api/v1/resteraunts",(req,res)=> {
    res.status(200).json({
        status: "success",
        data: {
            resteraunt: ["mcdonalds", "wendys"],
        },
    });
});

app.get("/api/v1/resteraunts/:id",(req,res)=> {
    console.log(req); 
});

app.listen(port, () => {
    console.log(`listening on port ${port}`);
});