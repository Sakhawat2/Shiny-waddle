import client from "../db/db.js"; 
import * as bcrypt from "https://deno.land/x/bcrypt/mod.ts"; // For password comparison  
import { z } from "https://deno.land/x/zod@v3.16.1/mod.ts"; // For valida on 
 
// Zod schema for login valida on 
const loginSchema = z.object({ 
    username: z.string().email({ message: "Invalid email address" }), 
    password: z.string().min(8, "Password must be at least 8 characters long"), 
}); 
 
// Helper func on to fetch the user by email 
async function getUserByEmail(email) { 
    const result = await client.queryArray( 
        `SELECT user_id, username, password_hash FROM zephyr_users WHERE username = $1`, 
        [email] 
    ); 
    return result.rows.length > 0 ? result.rows[0] : null; 
} 
 
// Handle user login 
export async function loginUser(c) { 
    const body = await c.req.parseBody(); 
    const { username, password } = body; 
 
    try { 
        // Validate the input data using Zod 
        loginSchema.parse({ username, password }); 
 
        // Fetch the user by email 
        const user = await getUserByEmail(username); 
        if (!user) { 
            return c.text("Invalid email or password", 400); 
        } 
 
        const [userId, storedUsername, storedPasswordHash] = user; 
 
        // Compare provided password with the stored hashed password 
        const passwordMatches = await bcrypt.compare(password, storedPasswordHash); 
        if (!passwordMatches) { 
            return c.text("Invalid email or password", 400); 
        } 
 
        // Authen ca on successful, proceed to create session or token 
        return c.text(`Welcome back, ${storedUsername}!`); 
 
    } catch (error) { 
        if (error instanceof z.ZodError) { 
            // Handle valida on errors from Zod 
            return c.text(`Valida on Error: ${error.errors.map(e => e.message).join(", ")}`, 400); 
        } 
 
        console.error(error); 
        return c.text("Error during login", 500); 
    } 
}