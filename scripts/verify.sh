#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC="$ROOT/public"
fail=0

require_file() {
  if [ ! -f "$PUBLIC/$1" ]; then
    printf 'missing required file: %s\n' "$1" >&2
    fail=1
  fi
}

for file in index.html 404.html robots.txt sitemap.xml llms.txt privacy.html security-checklist.html troubleshooting.html assets/style.css assets/favicon.svg; do
  require_file "$file"
done
for n in 01-prerequisites 02-neon-database 03-deploy-to-vercel 04-environment-variables 05-setup-wizard 06-license-and-lite-vs-pro 07-import-your-data 08-optional-keys-and-cron 09-custom-domain 10-updating; do
  require_file "guide/$n.html"
done

if ! node -e 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));' "$ROOT/vercel.json"; then
  printf 'vercel.json is not valid JSON\n' >&2
  fail=1
fi

# Static guide must not grow an outbound runtime or data collection surface.
if grep -RInE --include='*.html' --include='*.css' --include='*.js' \
  '(<form|localStorage|sessionStorage|indexedDB|fetch[[:space:]]*\(|XMLHttpRequest|navigator\.sendBeacon|gtag|google-analytics|googletagmanager|facebook\.com/tr)' "$PUBLIC"; then
  printf 'forbidden runtime/data-collection pattern found\n' >&2
  fail=1
fi

# Reject obvious secret formats. Placeholders are allowed, real-looking values are not.
if grep -RInE --exclude='style.css' --exclude='verify.sh' \
  '(postgres(ql)?://[^[:space:]]+:[^[:space:]]+@|sk_live_|rk_live_|whsec_|re_[A-Za-z0-9]{20,}|NW-[A-Za-z0-9._-]{12,}|-----BEGIN (RSA|OPENSSH|EC|PRIVATE) KEY-----)' "$ROOT"; then
  printf 'secret-like value found\n' >&2
  fail=1
fi

# Internal links should point to files in the static tree. Ignore external URLs,
# fragments, mailto links, and the Vercel deploy URL.
while IFS= read -r href; do
  case "$href" in
    http://*|https://*|mailto:*|tel:*|\#*|/api/*|javascript:*) continue ;;
  esac
  path="${href%%\#*}"
  [ -z "$path" ] && continue
  case "$path" in
    /*) target="$PUBLIC$path" ;;
    *) continue ;;
  esac
  target="${target%%\?*}"
  if [ ! -f "$target" ] && [ ! -d "$target" ]; then
    printf 'broken internal reference: %s\n' "$href" >&2
    fail=1
  fi
done < <(grep -RhoE 'href="/[^"]+"' "$PUBLIC" --include='*.html' | cut -d'"' -f2 | sort -u)

if [ "$fail" -ne 0 ]; then
  exit 1
fi
printf '✓ setup kit static checks passed\n'
