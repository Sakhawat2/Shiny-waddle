# Shiny-waddle
Cybersecurity and data privacy

# Logbook

## Table: Indepent work
| Date | Description | Used time |
| :---         |     :---:      |          ---: |
| 11/4/2024 | The Repo has been created after watch the tutorial | 15 min |
| 11/6/2024 | Lab: SQL injection vulnerability in WHERE clause allowing retrieval of hidden data | 15 min |
| 11/8/2024 | Lab: SQL injection vulnerability allowing login bypass | 30 min |
| 11/8/2024 | Lab: SQL injection attack, querying the database type and version on Oracle | 30 min |
| 11/8/2024 | Lab: SQL injection attack, querying the database type and version on MySQL and Microsoft | 30 min |
| 11/6/2024 | Lab: Username enumeration via different responses | 20 min |
| 11/9/2024 | Lab: 2FA simple bypass | 30 min |
| 11/9/2024 | Lab: Password reset broken logic | 30 min |
| 11/9/2024 | Lab: Username enumeration via response timing | 30 min |
| 11/7/2024 | Lab: Unprotected admin functionality | 15 min |
| 11/10/2024 | Lab: Unprotected admin functionality with unpredictable URL | 30 min |
| 11/10/2024 | Lab: User role controlled by request parameter | 30 min |
| 11/22/2024 | The Booking system project → Phase 1 | 8 hour |
| 11/28/2024 | The Booking system project → Phase 2 | 8 hour |
| 12/7/2024 | The Booking system project → Phase 3 | 8 hour |
| 12/12/2024 | The Booking system project → Phase 4 | 5 hour |



----------------------------------------------------------------------------------------------------------
## Introduction to the portswigger environment (Lab )
| Date | Topic (Lab) |Description (Lab) | Reflection Status |
| :---         |     :---:      |     :---:      |          ---: |
| 11/6/2024 | SQL injection | SQL injection vulnerability in WHERE clause allowing retrieval of hidden data | Submitted |
| 11/6/2024 | Authentication | Username enumeration via different responses | Submitted |
| 11/7/2024 | Access control | Unprotected admin functionality | Submitted |

------------------------------------------------------------------------------------------------------------------------
## The Booking system project → Phase 4

#### Attachments
| Topic | Link |
| :---         |     :---:      |
| Report| [Report](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/Generated%20Report-.md) |
| app.js| [app.js](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/app.js) |
| Phase 4| [Phase 4](https://github.com/Sakhawat2/Shiny-waddle/tree/main/TheBookingSystem_phase4) |




### Step 1: Add the Privacy Policy to the booking system
- Privacy Notice and Terms of Service page has been added and works smoothly.
- 
![step1](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/step1.jpg)

### Step 2: Add the terms of service to the booking system
- There are two check box has been added in Register page.

  ![Register](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/Register.jpg)
  
- There is one check box has been added in login page.
  ![login](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/Login.jpg)
- Some containt has been added into Privacy Notice and Terms of Service page.
- Register page has been tested. It is not possible to register without check.

  
  ![Terms of Service](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/Terms%20.jpg)

  

   ![Privacy Notice](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystem_phase4/Privacy.jpg)


### Step 3: Add the terms of service to the booking system
- Functional and security test has been done and satisfied.




---------------------------------------------------------------------------------------------------------------------------
## The Booking system project → Phase 3

#### Attachments
| Topic | Link |
| :---         |     :---:      |
| Report-1 Before fix| [Report](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystemphase3/First%20Report-.md) |
| Complete folder before fix| [TheBookingSystemPhase3](https://github.com/Sakhawat2/Shiny-waddle/tree/main/TheBookingSystemphase3) |
| app.jf After fix| [app.js]( https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystemphase3/app.js) |
| Report-2 After fix| [Report](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystemphase3After%20fix/Report_Afterfix.md) |
| Complete folder After fix| [[TheBookingSystemPhase3](https://github.com/Sakhawat2/Shiny-waddle/tree/main/TheBookingSystemphase3After%20fix)
| app.js After fix| [app.js](https://github.com/Sakhawat2/Shiny-waddle/blob/main/TheBookingSystemphase3After%20fix/app.js) |

### Security check 
Most 5 important points need to fix as soon as possible.

1. **Error Handling and Logging**: There is a lack of error handling and logging across various functions, particularly in the serveStaticFile function. By reviewing the serveStaticFile function and noticing the absence of detailed error logging. To solve, below code has been **implemented**.

   
 // Serve static files
 
async function serveStaticFile(path, contentType) {

    try {
    
        const data = await Deno.readFile(path);
        
        return new Response(data, {
        
            headers: { "Content-Type": contentType },
            
        });
        
    } catch (error) {
    
        console.error("File not found:", path, error);
        
        return new Response("File not found", { status: 404 });
        
    }    
}

2. **Utility Function for Content Type**: The getContentType function needs to ensure it covers a comprehensive range of MIME types. It found by examining the getContentType function and its use for static file serving. To solve, below code has been **implemented**.

   // Utility: Get content type for static files
   
function getContentType(filePath) {

    const ext = filePath.split(".").pop();
    
    const mimeTypes = {
    
        html: "text/html",
        
        css: "text/css",
        
        js: "application/javascript",
        
        png: "image/png",
        
        jpg: "image/jpeg",
        
        jpeg: "image/jpeg",
        
        gif: "image/gif",
        
        svg: "image/svg+xml",
        
        json: "application/json",
        
    };
    
    return mimeTypes[ext] || "application/octet-stream";
    
}

3. **Typo in File Path Concatenation**: There's a typo in the code when concatenating the file path for serving static files. It found by examining the serveStaticFile function and its invocation in the route handling. Correct the typo in the file path concatenation. The line should be:

   const filePath = `.${url.pathname}`;

   4. **Missing Initialization of sessionStore**: The session store is not properly initialized within app.js. it found by reviewing the code and noticing the direct use of sessionStore without proper initialization. Need to sessionStore is initialized correctly and used consistently within sessionService.js.
  
   5. **Inconsistent Response Headers**: The addSecurityHeaders function uses a deprecated pattern. It found by examining how the security headers are set within the addSecurityHeaders function. To solve, below code has been added.(**implemented**)
      

      async function addSecurityHeaders(req, handler) {
      
  const response = await handler(req);
  

  response.headers.set("Content-Security-Policy",
  
      "default-src 'self'; " +

      "script-src 'self'; " +
      
      "style-src 'self'; " +
      
      "img-src 'self'; " +
      
      "frame-ancestors 'none'; " +
      
      "form-action 'self';");
      
  response.headers.set("X-Frame-Options", "DENY");
  
  response.headers.set("X-Content-Type-Options", "nosniff"); 
  return response;  
}





 







---------------------------------------------------------------------------------------------------------------------
## The Booking system project → Phase 2
1. [Link to first report](https://github.com/Sakhawat2/Shiny-waddle/blob/main/project%20%E2%86%92%20Phase%202/Before_fix/First%20before%20fixing-.md)
2. [Link to app.js](https://github.com/Sakhawat2/Shiny-waddle/blob/main/project%20%E2%86%92%20Phase%202/Before_fix/app.js)
3. [Link to whole code for before fix](https://github.com/Sakhawat2/Shiny-waddle/tree/main/project%20%E2%86%92%20Phase%202/Before_fix)
4. [Link to Second Report]( https://github.com/Sakhawat2/Shiny-waddle/blob/main/After_fix/SecondReport-.md)
5. [Link to app.js_second](https://github.com/Sakhawat2/Shiny-waddle/blob/main/After_fix/app.js)
6. [Link to whole code](https://github.com/Sakhawat2/Shiny-waddle/tree/main/After_fix)
   
### Details Report
a.	Implemented the index page

b.	Solved the Content Security Policy (CSP) Header alert.

Added into app.js


// Middleware to set CSP header

app.use('*', (c, next) => {

    c.header('Content-Security-Policy', "default-src 'self'");
    
    return next(); })

----------------------------------------------------------------------------------------------------
## The Booking system project → Phase 1
1. [First Report](First_generate_report.MD)

2. [Second Report](Second_generate_report.MD) 

### Details
There were 6 Alart. There were 6 risks. Alert Path Traversal and SQL Injection was high. Content Security Policy (CSP) Header Not Set and Missing Anti-clickjacking Header alert is medium. X-Content-Type-Options Header Missing alert is low and User Agent Fuzzer is Informational. 

![First Report Summary](First.jpg)





















