# Week 6 Deployment Guide — DSA Log

## 1. Project and deployment target

DSA Log is a full-stack DSA practice tracker built with a vanilla HTML/CSS/JavaScript client and a Node.js/Express REST API backed by SQLite.

For this version, Railway is used as the deployment platform because the application already uses a local SQLite database and Railway Volumes can provide persistent storage for the application's `data` directory. Railway supports GitHub-based deployments, environment variables, health checks and persistent volumes.

**Important:** A Railway Volume must be mounted at `/app/data` and `DB_PATH` must be set to `/app/data/dsa-log.db`. Without persistent storage, SQLite data would be lost when the service filesystem is replaced.

## 2. Production prerequisites

- GitHub account
- Railway account
- Node.js 22 LTS for local verification and deployment
- Project pushed to a GitHub repository
- A strong production `JWT_SECRET`
- A Railway Volume mounted at `/app/data`

## 3. Prepare the repository

The repository should contain:

```text
dsa-log-fullstack/
├── client/
├── server/
├── docs/
├── README.md
├── WEEK5_README.md
├── DEMO_SCRIPT.md
└── .gitignore
```

Do not commit:

- `.env`
- database files such as `server/data/*.db`
- passwords
- JWT secrets
- API keys
- npm debug logs

The supplied `.gitignore` is retained for this purpose.

## 4. Test before deployment

From `server/`:

```bash
npm ci
npm run check
npm run test:unit
npm run test:integration
npm test
```

The Week 5 project already includes API, unit, frontend API-client and static-structure tests.

If `npm ci` cannot install native dependencies in a particular environment, use a Node.js 22.x and rerun the installation. Do not mark the integration suite as passed unless it actually executes.

## 5. Create the Railway service

**Recommended deployment path:** the submission now includes a root `Dockerfile` that builds the complete application with Node.js 22 LTS. This avoids Railway having to infer the runtime from the repository root and keeps the native SQLite dependency on a controlled Node runtime. Railway supports Dockerfile-based builds and uses a detected Dockerfile automatically; if needed, the Dockerfile path can be set explicitly in service settings.


1. Push the project to GitHub.
2. Sign in to Railway.
3. Create a new project.
4. Choose **Deploy from GitHub repo**.
5. Select the DSA Log repository.
6. Keep the service root directory at `/` so the root `Dockerfile` can copy both `server/` and `client/`.
7. Leave Build Command and Start Command empty so Railway uses the Dockerfile `CMD`. If Railway asks for a Dockerfile path, use `/Dockerfile`.

Railway provides the `PORT` environment variable automatically. The application already reads `process.env.PORT`.

## 6. Configure environment variables

Set these in Railway:

```text
NODE_ENV=production
JWT_SECRET=<long-random-secret>
JWT_EXPIRES_IN=1h
DB_PATH=/app/data/dsa-log.db
BCRYPT_ROUNDS=10
CORS_ORIGIN=https://<your-railway-domain>
```

Do not copy the development fallback JWT secret into production.

After Railway generates the public domain, replace `<your-railway-domain>` with the exact application origin.

Because the frontend and API are served from the same Express application, `CORS_ORIGIN` can be restricted to the application's public origin instead of using `*`.

## 7. Configure persistent SQLite storage

Create a Railway Volume and attach it to the DSA Log service.

Use:

```text
Mount path: /app/data
```

The application creates the database directory automatically. With:

```text
DB_PATH=/app/data/dsa-log.db
```

the SQLite database is stored on the persistent volume rather than the ephemeral application filesystem.

Do not run multiple service replicas while using one SQLite volume.

## 8. Configure the health check

Use:

```text
Health check path: /api/health
```

The existing endpoint returns HTTP 200 with:

```json
{"status":"ok"}
```

Railway can use this endpoint to determine whether a new deployment is ready to receive traffic.

## 9. Verify the deployment

After deployment:

1. Open the Railway-generated public URL.
2. Confirm the landing page loads.
3. Open the login page.
4. Register a test account.
5. Confirm seeded DSA topics appear.
6. Open a topic.
7. Mark a problem as solved.
8. Confirm progress changes.
9. Refresh the page and verify saved progress remains.
10. Create a topic.
11. Add a problem.
12. Edit notes.
13. Test search/filtering.
14. Log out.
15. Confirm protected pages redirect to login.
16. Open `/api/health` and confirm a successful response.
17. Check Railway deployment logs for startup errors.

## 10. User Acceptance Test checklist

| ID | Test | Expected result |
|---|---|---|
| UAT-01 | Open public URL | Landing page loads |
| UAT-02 | Register account | Account created and dashboard opens |
| UAT-03 | Login | Valid credentials return authenticated session |
| UAT-04 | Invalid login | Generic authentication error is displayed |
| UAT-05 | View topics | Seeded topics appear |
| UAT-06 | Create topic | New topic is displayed |
| UAT-07 | Add problem | Problem appears under selected topic |
| UAT-08 | Mark problem solved | Progress updates |
| UAT-09 | Refresh page | Persisted data remains |
| UAT-10 | Search/filter | Matching topics/problems are returned |
| UAT-11 | Edit notes | Notes persist after refresh |
| UAT-12 | Logout | Protected pages require authentication |
| UAT-13 | Health endpoint | `/api/health` returns 200 |
| UAT-14 | Restart/redeploy | Data remains because SQLite is on the volume |

Record the actual public URL, date, browser, and observed result after completing these tests.

## 11. Common deployment problems

### Application does not start

Check:

```bash
npm start
```

Confirm Railway's start command is correct and that `PORT` is not hard-coded.

### `JWT_SECRET must be set in production`

Set a non-empty `JWT_SECRET` Railway variable.

### Database disappears after deployment

Check that a Railway Volume exists and is mounted at:

```text
/app/data
```

Also check:

```text
DB_PATH=/app/data/dsa-log.db
```

### SQLite permission/path error

Confirm the configured path is writable and that the parent directory exists. The server creates the parent directory during startup.

### CORS errors

Because this project serves the frontend from the same Express server, frontend API requests use relative `/api/...` URLs. If CORS is required, set `CORS_ORIGIN` to the exact public origin rather than an incorrect URL.

### Health check fails

Confirm:

- The application listens on Railway's `PORT`.
- `/api/health` returns 200.
- The service is not crashing during startup.
- The volume is mounted at the expected path.

### Native SQLite dependency installation failure

`better-sqlite3` is a native dependency. Use a current supported Node.js version and reinstall dependencies. Railway's Node build environment should install the dependency during the build.

## 12. Rollback procedure

If a new deployment introduces a regression:

1. Open Railway deployment history.
2. Identify the last known-good deployment.
3. Redeploy/rollback according to the Railway deployment controls.
4. Check `/api/health`.
5. Run the UAT checklist again.
6. Review logs before making another code change.

## 13. Deployment security checklist

- [ ] Production JWT secret is stored only as an environment variable.
- [ ] `.env` is not committed.
- [ ] Database files are not committed.
- [ ] HTTPS is provided by the hosting platform.
- [ ] Helmet security headers remain enabled.
- [ ] Request body size is limited.
- [ ] Login rate limiting remains enabled.
- [ ] Passwords are hashed with bcrypt.
- [ ] SQL queries use parameterized statements.
- [ ] Zod validates request input.
- [ ] User data is scoped to the authenticated user.
- [ ] User-entered content is HTML-escaped before display.
- [ ] CORS is restricted to the production origin.

## 14. Official deployment references

Railway Express deployment guide:
https://docs.railway.com/guides/express

Railway volumes:
https://docs.railway.com/volumes

Railway health checks:
https://docs.railway.com/deployments/healthchecks

Railway GitHub deployments:
https://docs.railway.com/deployments/github-autodeploys
