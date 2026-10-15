# Security

The Setup Kit is documentation, not an authenticated application.

- Do not publish database URLs, passwords, license keys, API keys, webhook secrets, customer records, or financial figures.
- Do not add analytics, forms, cookies, third-party embeds, or scripts that send data anywhere.
- Treat the URL as unlisted-public. `noindex` and `robots.txt` reduce discovery but do not prevent access.
- Report a suspected disclosure to `security@nomadwealth.app` without including the secret in the report. Describe the location and rotate the exposed value first.
- Keep the repository and Vercel project separate from the NomadWealth buyer deploy template.

This site has no database and no server-side request path. Buyers should put secrets only in their own password manager, Vercel project settings, Neon console, or local terminal.
