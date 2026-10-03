# DSA Log — Week 6 Submission

This package completes the Week 6 deployment, maintenance and reflection work for the DSA Log full-stack application.

## Included

- `docs/WEEK6_DEPLOYMENT_GUIDE.md` — production deployment instructions.
- `docs/WEEK6_MAINTENANCE_PLAN.md` — logging, error handling, backups, updates and incident response.
- `docs/WEEK6_PROJECT_REFLECTION.md` — development reflection, challenges, lessons and future improvements.
- `docs/WEEK6_UAT_RECORD.md` — public deployment acceptance checklist.
- Existing Week 5 tests, debugging documentation and source code.

## Deployment target

Railway is used in the guide because the application uses SQLite and requires persistent storage for production data. Attach a Railway Volume at `/app/data` and set:

```text
DB_PATH=/app/data/dsa-log.db
```

## Current verification

During preparation, the dependency-free JavaScript test subset passed:

```text
11 tests passed
0 failed
```

The full Supertest integration suite should be run after normal dependency installation.

## Final portal items

1. Upload the generated Week 6 Word report.
2. Paste the 200+ word Week 6 project description.
3. Paste the GitHub repository URL after pushing this project to GitHub.

The public deployment URL should also be recorded in the report/UAT table after the application is deployed.
