# Deployment Checklist

- [ ] Push repository to GitHub.
- [ ] Create Railway service from GitHub.
- [ ] Railway detects the root `Dockerfile` and builds with Node.js 22 LTS.
- [ ] If Dockerfile is not auto-detected, set Dockerfile path to `/Dockerfile`.
- [ ] Set `NODE_ENV=production`.
- [ ] Set a strong `JWT_SECRET`.
- [ ] Set `DB_PATH=/app/data/dsa-log.db`.
- [ ] Set `CORS_ORIGIN` to the exact public origin.
- [ ] Set `BCRYPT_ROUNDS=10`.
- [ ] Attach a persistent volume at `/app/data`.
- [ ] Configure health check `/api/health`.
- [ ] Deploy.
- [ ] Execute the Week 6 UAT checklist.
- [ ] Record the public URL in the report.
