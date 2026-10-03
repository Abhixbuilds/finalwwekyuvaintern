# Week 6 Maintenance Plan — DSA Log

## 1. Maintenance objective

The maintenance strategy keeps DSA Log available, secure, testable and recoverable after deployment. Maintenance is divided into operational monitoring, error handling, database protection, dependency updates, security review and release management.

## 2. Logging

The application already reports server startup information and unexpected server errors to standard output. Railway collects service logs, which should be reviewed when:

- a deployment fails;
- the application restarts unexpectedly;
- users report API failures;
- authentication begins failing;
- database errors occur.

Operational checks should focus on HTTP status patterns, repeated authentication failures, startup errors and database exceptions.

For future scaling, logs should be structured as JSON and forwarded to a centralized logging service.

## 3. Health monitoring

The application exposes:

```text
GET /api/health
```

Expected response:

```json
{"status":"ok"}
```

This endpoint is suitable for deployment health checks.

A production maintenance routine should check application availability after every deployment and after significant configuration changes.

## 4. Error reporting

Unexpected server exceptions are handled by the Express error middleware. Internal error details are written to server logs while the client receives a generic `Internal server error` response.

Expected client-facing error categories include:

- 400 validation errors;
- 401 authentication errors;
- 404 missing resources;
- 409 duplicate accounts;
- 413 oversized request bodies;
- 500 unexpected server errors.

For a larger production version, integrate an error-monitoring service such as Sentry or an equivalent platform.

## 5. Database maintenance

The application uses SQLite. The production database must live on persistent storage.

Maintenance tasks:

- Take regular database backups.
- Verify that backups can actually be restored.
- Monitor database file size.
- Keep the persistent volume capacity below its safe operating limit.
- Avoid running multiple application instances against the same SQLite database.
- Test schema changes on a copy before applying them to production.

A future scaled version should migrate to PostgreSQL because SQLite is not intended for horizontally scaled multi-instance deployments.

## 6. Backup procedure

At minimum:

1. Stop writes if a consistent backup is required.
2. Copy the SQLite database file from persistent storage.
3. Store the backup outside the application volume.
4. Record the backup date.
5. Periodically restore a backup into a test database.
6. Verify users, topics and problems after restoration.

Backups should be retained according to the project's data requirements.

## 7. Dependency updates

Review npm dependencies periodically.

Recommended procedure:

```bash
npm outdated
npm audit
npm test
```

Then:

1. Update dependencies in a controlled branch.
2. Run syntax checks.
3. Run unit and frontend tests.
4. Run the complete integration suite.
5. Manually test authentication and core CRUD flows.
6. Deploy to the production service.
7. Re-run the UAT checklist.

Do not update multiple major dependencies blindly in a production release.

## 8. Security maintenance

Review regularly:

- JWT secret management.
- Authentication and authorization.
- Password hashing configuration.
- Rate limiting.
- Helmet/CSP headers.
- Input validation.
- SQL parameterization.
- XSS escaping.
- CORS origin.
- npm dependency vulnerabilities.
- Repository secrets.

If the JWT secret must be rotated, understand that existing tokens will become invalid after the new secret is applied.

## 9. Release procedure

### Before release

- Review changed files.
- Run `npm run check`.
- Run `npm test`.
- Review security-sensitive changes.
- Confirm environment variables.
- Confirm database backup availability.

### During release

- Push the approved commit.
- Monitor build output.
- Wait for the health check.
- Review application logs.

### After release

- Open the public URL.
- Test registration/login.
- Test topic and problem CRUD.
- Test persistence after refresh.
- Test `/api/health`.
- Record the release result.

## 10. Incident response

For a production incident:

1. Identify whether the problem is application, configuration, dependency or database related.
2. Review deployment history.
3. Review application logs.
4. Roll back if a recent deployment caused the problem.
5. Verify health and UAT flows.
6. Restore the database only when data corruption/loss is confirmed.
7. Document the root cause and corrective action.

## 11. Maintenance schedule

| Frequency | Activity |
|---|---|
| Every deployment | Health check, smoke test, logs |
| Weekly | Review recent errors and deployment history |
| Monthly | Dependency/security review and backup restore test |
| Quarterly | Full security review, disaster-recovery drill and architecture review |
| Before major release | Full automated test suite and UAT |

## 12. Future maintenance improvements

- Structured application logging.
- External error monitoring.
- Automated database backups.
- PostgreSQL migration for larger scale.
- Automated CI/CD tests on every pull request.
- Refresh-token/session management.
- Password reset and email verification.
