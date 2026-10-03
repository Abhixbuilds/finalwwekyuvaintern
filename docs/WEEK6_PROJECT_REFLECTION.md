# Week 6 Project Reflection — DSA Log

## 1. Project overview

DSA Log evolved from a front-end DSA practice tracker into a full-stack application. The final architecture uses a vanilla HTML/CSS/JavaScript client, an Express REST API, JWT authentication, SQLite persistence and middleware for validation, security and error handling.

The project demonstrates the transition from a static/local application to a server-backed application with user accounts, persistent data and automated testing.

## 2. What went well

A major success was maintaining a clear separation between the client and API responsibilities. The front end communicates through a single API client, while the Express application owns authentication, validation, database access and business rules.

Authentication and data isolation were also implemented early enough to influence the final design. Passwords are hashed with bcrypt, JWTs are used for authenticated API access, and database queries scope topics and problems to the authenticated user.

The Week 5 work strengthened the project further. Automated tests cover progress calculations, the frontend API client, API behavior and static frontend structure. Database-side filtering and a composite index also reduced unnecessary application-level filtering.

Security was treated as part of development rather than as an afterthought. Helmet, CSP-related restrictions, rate limiting, request size limits, Zod validation, parameterized SQL and HTML escaping were incorporated into the final application.

## 3. Challenges faced

One challenge was integrating the Week 2 frontend data model with the Week 3 API. The earlier front end relied on localStorage and a static data model, while the API introduced numeric database identifiers, authenticated users and nested problem data. The page scripts had to be redesigned around the API response shapes.

Another challenge was handling browser security and CSP restrictions. Inline styles and scripts that worked during early frontend development were not appropriate once Helmet and CSP were introduced. The application was changed to use external scripts and data attributes.

Testing was another practical challenge. The Week 5 verification environment could execute the dependency-free tests, but the complete Supertest integration suite could not be executed because the required third-party dependency was not usable in that environment and the npm registry could not be reached. Instead of presenting unverified integration results as successful, the limitation was documented.

Deployment adds another real-world concern: the application uses SQLite. A normal ephemeral cloud filesystem is not sufficient for persistent user data. The deployment design therefore requires persistent storage and explicitly configures the database path.

## 4. Lessons learned

The project showed that deployment is not simply uploading source code to a server. Production configuration, secrets, persistent storage, health checks, monitoring and rollback procedures are part of the application lifecycle.

Another lesson was that testing should be reproducible. A test result is only meaningful when the environment and dependencies allow the test to actually execute. This changed the way verification results were documented.

The project also reinforced the importance of moving data filtering to the database when appropriate. The Week 5 optimization work made the code more efficient while preserving the API response contract.

## 5. Areas for self-improvement

The project can be improved by introducing continuous integration so every change automatically runs syntax checks and the complete test suite.

The authentication design could also be strengthened with httpOnly secure cookies, refresh-token/session management, email verification and password reset.

SQLite is appropriate for this project's current scope, but a production application expected to scale horizontally should use PostgreSQL or another shared database system.

Operational observability is another area for improvement. The current project has useful error handling and platform logs, but structured logging and an external error-monitoring service would make production diagnosis more effective.

## 6. Future project approach

For future projects, I would establish the production architecture earlier, define the deployment environment before final integration, introduce automated CI sooner, and test deployment assumptions before the final development week.

I would also plan database migration and backup requirements at the beginning rather than treating persistence as a final deployment concern.

## 7. Overall reflection

The most important outcome of this project was learning the complete lifecycle of a web application rather than only its coding portion. The work progressed from frontend design to API development, authentication, database persistence, integration, testing, debugging, optimization and finally deployment planning.

The Week 6 stage makes the project closer to a real software product because it requires thinking about what happens after development: how the application is deployed, how data survives restarts, how failures are detected, how updates are released and how the system can be maintained over time.
