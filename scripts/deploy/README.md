# Landing page deploy

Lokaal one-shot deploy script voor de Next.js statische landingspagina
(`bear_adventure_landing_page/`) naar
`bearappqr.lotus.hosted-temp.com`.

## Hoe werkt het

```
┌────────────────────┐         npm ci + next build           ┌──────────┐
│  jouw laptop       │ ────────────────────────────────────▶ │  out/    │
│  (achter VPN)      │                                        └────┬─────┘
└────────┬───────────┘                                             │
         │  scp + ssh                              tar -czf  ──────┘
         │  via ~/.ssh/io_key_2
         ▼
┌──────────────────────────────────────────────────────────────────┐
│  bearappqr@web.prod.lotus.cloud.intracto.com                     │
│                                                                  │
│  /var/www/bearappqr.lotus.hosted-temp.com/                       │
│  ├── releases/                                                   │
│  │   ├── 20260520131500-abc1234/htdocs/  ← deze deploy            │
│  │   ├── 20260519...                      ← oudere (max 5)        │
│  │   └── ...                                                     │
│  └── current → releases/20260520131500-abc1234   (symlink)       │
└──────────────────────────────────────────────────────────────────┘
```

Deploys gebeuren **handmatig** vanaf je laptop, niet via GitHub Actions.
Reden: de server zit achter VPN en GitHub-hosted runners kunnen er
niet aan, en een serverside polling-oplossing zou een PAT met
org-approval vereisen.

Het script:

1. Draait `npm ci` + `npm run build` in `bear_adventure_landing_page/`.
2. Pakt `out/` in als tarball.
3. Upload via `scp` naar een tmp-pad op de server.
4. Op de server: nieuwe `releases/<UTC-timestamp>-<sha7>/htdocs/`
   aanmaken, tarball uitpakken, `current` symlink atomisch flippen
   (`ln -sfn` + `mv -Tf`).
5. Oude releases prunen (laatste 5 bewaren).

Atomische symlink-flip betekent: zero downtime tijdens deploys.

## Vereisten

- VPN-toegang tot het iO netwerk.
- SSH-key in `~/.ssh/io_key_2` (of override via `-i`).
- Lokaal: `node`, `npm`, `tar`, `git`, `ssh`, `scp`, `bash`.

## Gebruik

Vanuit de root van de repo:

```bash
scripts/deploy/deploy-landing-page.sh
```

Opties:

```bash
scripts/deploy/deploy-landing-page.sh --skip-build   # gebruik bestaande out/
scripts/deploy/deploy-landing-page.sh --dry-run      # build + toon plan
scripts/deploy/deploy-landing-page.sh -i ~/.ssh/anders_key
scripts/deploy/deploy-landing-page.sh --keep 10      # bewaar 10 releases ipv 5
```

Het script waarschuwt als je uncommitted changes hebt in
`bear_adventure_landing_page/` en markeert die deploy als `-dirty` in de
release-naam.

## Rollback

Vanaf je laptop:

```bash
ssh -i ~/.ssh/io_key_2 bearappqr@web.prod.lotus.cloud.intracto.com '
    ls -la /var/www/bearappqr.lotus.hosted-temp.com/releases/
'
```

Symlink terugzetten naar een eerdere release:

```bash
ssh -i ~/.ssh/io_key_2 bearappqr@web.prod.lotus.cloud.intracto.com '
    cd /var/www/bearappqr.lotus.hosted-temp.com
    ln -sfn releases/<oudere-release-id> current.new
    mv -Tf current.new current
    readlink -f current
'
```

## Eerste deploy

Werkt out-of-the-box: het script maakt automatisch `releases/` aan en
flipt de `current` symlink van de initial-release map naar je nieuwe
release.
