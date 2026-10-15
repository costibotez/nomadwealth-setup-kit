# NomadWealth Private Setup Kit

A standalone, static onboarding guide for NomadWealth buyers. It is intentionally separate from the NomadWealth application and the public deploy-template repository.

## Local preview

No package manager or build step is required:

```bash
python3 -m http.server 4173 --directory public
```

Then open <http://localhost:4173/>. Run `scripts/verify.sh` before publishing.

## Deploy

Import this repository into a new Vercel project as **Other**. Keep the root directory unchanged, set no environment variables, and deploy the `public/` directory. Add a custom subdomain only after the Vercel preview has passed the checks below.

The site intentionally has no forms, analytics, cookies, API routes, third-party scripts, fonts, or runtime network calls. It contains placeholders only. Never add credentials, license keys, customer records, portfolio figures, or bearer tokens here.

## Privacy and access

This URL is an unlisted convenience handoff, not authentication. Anyone who learns it can read the documentation. The site is marked `noindex`; that is not a security boundary. Keep the content safe for public disclosure.

## Verification

```bash
./scripts/verify.sh
```

The script checks the static tree for broken local references, network-capable browser code, analytics, forms, and secret-like values.
