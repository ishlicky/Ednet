const express = require("express");
const mysql = require("mysql2");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const cors = require("cors");
// ES6
// import express from "express";

const app = express();
const conn = mysql.createConnection({
  host: "localhost",
  port: 3306,
  user: "root",
  password: "123",
  database: "l4sod",
});

conn.connect((err)=>{
    if(err){
        console.log(err);
        process.exit(1);
    }

    // or
    //if (err) throw err;
    console.log("Database connected");
});

app.use(express.json());
app.use(cors());

const checkLogin = (req, res, next) => {
try {
    const authHeader = req.headers.authorization;
    if(!authHeader){
        return res.status(401).json({message: "Unauthorized"})
    }
    const [bearer, token] = authHeader.split(" ");
    const tokenData = jwt.verify(token, "jhdfvsdfgcdjwtssfsf");
    
    // check if the user exist in database
    const sql = "select * from users where user_id=?";
    conn.query(sql, [tokenData.user_id], (err, result)=>{
        if(err){
            console.log(err);
            
            return res.status(500).json({message: "Error occured"})
        }
        if(!result.length){
            return res.status(404).json({message: "Account not found"});
        };
        req.user = result[0];
        next();
    })
} catch (error) {
    console.log(error);
    res.status(401).json({message: error.message});
}
}

const  checkIsAdmin = (req, res, next) =>{
    try {
        console.log(req.user);
        
        if(req.user.role !== "admin"){
            return res.status(403).json({message: "Not enough previlages"})
        }
        next();
    } catch (error) {
        console.log(error);
        res.status(401).json({message: error.message});
    }
}

app.get("/", (req, res) => {
  return res.send("Welcome to server 2");
});

app.get("/users", checkLogin, checkIsAdmin, (req, res)=>{
    try {
        console.log(req.user);
        
        const { limit = 10, page = 1 } = req.query;
        const offset = (parseInt(page) -1) * parseInt(limit);

        const query="select * from users limit ? offset ?";
        conn.query(query, [parseInt(limit), offset], (err, result)=>{
            if(err) {
                console.log(err);
                return res.status(500).json({message: "Error occured"})
            }
            return res.status(200).json(result);
        });
    } catch (error) {
        console.log(error);
        res.status(500).json({
            message: "Server error",
        })
    }
});

// retrieve a single record using params
app.get("/users/:user_id", (req, res)=>{
    const { user_id } = req.params;
    
    //or 
    // const user_id = req.params.user_id;

    // const sql = `select * from users where user_id=${user_id}`;

    // prepared statements
    const sql = `select * from users where user_id=?`;
    conn.query(sql, [user_id], (err, results)=>{
        if(err) {
            console.log(err);
            return res.status(500).json({message: "Error occured"})
        };
        if(results.length === 0){
            return res.status(404).json({message: "User not found"})
        }
        return res.status(200).json(results[0]);
    })
});

app.delete("/users/:user_id", (req, res)=>{
    const { user_id } = req.params;
    const sql = "delete from users where user_id=?";
    conn.query(sql, [user_id], (err, result)=>{
        if(err) {
            console.log(err);
            return res.status(500).json({message: "Error occured"})
        };
        if(result.affectedRows === 0){
            return res.status(404).json({message: "No record to delete"})
        }
        return res.status(204).json({message: "User deleted"});
    })
});

app.post("/users", async (req, res)=>{
    try {
        const { password, username, email } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    const sql =`
    insert into users (password, Email, user_name) values
    (?,?,?)`;

    conn.query(sql, [hashedPassword, email, username], (err, result)=>{
        if(err) {
            console.log(err);
            return res.status(500).json({message: "Error occured"})
        };
       conn.query(
        `select * from users where user_id=${result.insertId}`,
        (insertError, insertedRes)=>{
            if(insertError) {
                console.log(insertError);
                return res.status(500).json({message: "Error occured"})
            };
            return res.json(insertedRes[0]);
        }
    )
    })

    } catch (error) {
        console.log(error);
        res.status(500).json({message: "Server error"});
    }
});

app.put("/users/:user_id", async (req, res)=>{
    try {
        const { username, email } = req.body;
        const { user_id } = req.params;
    
    const sql =`
    update users set Email=?, user_name=? where user_id=?`;

    conn.query(sql, [email, username, user_id], (err, result)=>{
        if(err) {
            console.log(err);
            return res.status(500).json({message: "Error occured"})
        };
        if(result.affectedRows === 0){
            return res.status(404).json({message: "User not found"})
        }
       conn.query(
        `select * from users where user_id=?`, [user_id],
        (insertError, insertedRes)=>{
            if(insertError) {
                console.log(insertError);
                return res.status(500).json({message: "Error occured"})
            };
            return res.json(insertedRes[0]);
        }
    )
        
    })

    } catch (error) {
        console.log(error);
        res.status(500).json({message: "Server error"});
    }
});

app.get("/users-with-transactios", (req, res)=>{
    const sql = `select u.*,
    tr.id as transaction_id,
    tr.user_id as transaction_user_id,
    tr.amount,
    tr.status,
    tr.created_at as t_created_at,
    tr.updated_at as t_updated_at
    from users u left join transactions tr on u.user_id=tr.user_id`;
    conn.query(sql, (err, result)=>{
        if(err){
            return res.status(500).json({message: err.message});
        };
        const returnData = [];
        result.forEach((record)=>{
            const foundRecord = returnData.find((data)=>data.user_id === record.user_id);
            if(foundRecord){
                foundRecord.transactions.push({
                    transaction_id: record.transaction_id,
                    transaction_user_id: record.transaction_user_id,
                    amount: record.amount,
                    status: record.status,
                    t_created_at: record.t_created_at,
                    t_updated_at: record.t_updated_at
                })
            }else{
                const newRecord =  {
                    user_id: record.user_id,
                    user_name: record.user_name,
                    password: record.password,
                    Email: record.Email,
                    created_at: record.created_at,
                    updated_at: record.updated_at,
                    role: record.role,
                    transactions: []
                  }

                  if(record.transaction_id){
                    newRecord.transactions.push({
                        transaction_id: record.transaction_id,
                        transaction_user_id: record.transaction_user_id,
                        amount: record.amount,
                        status: record.status,
                        t_created_at: record.t_created_at,
                        t_updated_at: record.t_updated_at
                    })
                  }
                  returnData.push(newRecord);
            }
        })
        return res.json(returnData);
    })
});

app.post("/login", (req, res)=>{
    try {
        const { email, password } = req.body;
        const sql = "select * from users where Email=?";
        conn.query(sql, [email], (err, result)=>{
            if(err){
                console.log(err);
                return res.status(500).json({mesage: "Error occured"})
            };
            if(!result.length){
                return res.status(401).json({message: "User not found"})
            }
            const user = result[0];
            const isPasswordCorrect = bcrypt.compareSync(password, user.password);
            if(!isPasswordCorrect){
                return res.status(400).json({message: "Incorrect password"});
            }
            const token = jwt.sign({user_id: user.user_id}, "jhdfvsdfgcdjwtssfsf", {expiresIn: "2h"});
            return res.json({user, token});
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).json({message: "Server failure"})
    }
})

app.post("/create-transaction", checkLogin, (req, res)=>{
    try {
        const user_id = req.user.id;
        const amount = req.body.amount; // or const { amount } = req.body;
        const sql = "insert into transactions (user_id, amount) values (?,?)";

        conn.query(sql, [user_id, amount], (err, result)=>{
            if(err){
                console.log(err);
                return res.status(500).json({message: err.message});
            };
            const query = `select * from transactions where id=${result.insertId}`;
            conn.query(query, (err2, result2)=>{
                if(err2){
                    return res.status(500).json({message: err2.message});
                };
                return res.status(201).json(result2[0]);
            })
        })
        
    } catch (error) {
        console.log(error);
        res.status(500).json({message: "Server failure"})
    }
})

app.use((req, res)=>{
    res.status(404).json({message: "Endpoint not found"})
})

app.listen(2500, () => console.log("Server is running on port 2500"));
