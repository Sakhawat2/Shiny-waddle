// app.js
import { Hono } from "https://deno.land/x/hono/mod.ts";
import { loginUser } from "./routes/login.js"; // Import login logic
import { registerUser } from "./routes/register.js"; // Import register logic
const app = new Hono();

// Serve the registration form
app.get("/register", async (c) => {
    return c.html(await Deno.readTextFile("./views/register.html"));
});

// Route for user registration (POST request)
app.post("/register", registerUser);

// Serve login page
app.get("/login", async (c) => {
    return c.html(await Deno.readTextFile("./views/login.html")); // Use the login.html file
});

// Handle user login
app.post("/login", loginUser);

Deno.serve(app.fetch);

// Run the app using the command:
// deno run --allow-net --allow-env --allow-read --watch app.js
