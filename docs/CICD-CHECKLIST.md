# Secrets checklist — BEAR Adventure CI/CD

Live status van setup. Zie [`CICD.md`](./CICD.md) voor volledige uitleg en
[`SETUP-PROGRESS.md`](./SETUP-PROGRESS.md) voor blockers.

> Legenda: ✅ klaar — 🟡 in progress / blocked — ⬜ pending

---

## Klant-acties

### Apple
- ✅ App Store Connect app aangemaakt voor `com.bearsnacks.bearadventure` (App ID `6768928418`)
- ✅ Apple Team ID: `24NC63RDSP` (Lotus Bakeries Corporate)
- 🟡 App Store Connect API Key (`.p8`) — **wacht op blocker B-1** (Sofie moet API access activeren)
- ✅ Apple ID account voor fastlane: `samuel.joos@iodigital.com`

### Google Play
- 🟡 Play Console app aangemaakt voor `com.bearsnacks.bearadventure` — **wacht op blocker B-2**
- 🟡 Privacy policy URL: `https://bearsnacks.com/en-us/disclaimer`
- ⬜ Play Console store listing items (content rating, target audience, data safety)
- 🟡 Service account JSON met Release Manager rol — **wacht op blocker B-2**
- ⬜ Eerste handmatige Play Store internal release (NIET via CI)

### Firebase
- ✅ iOS app toegevoegd met bundle ID `com.bearsnacks.bearadventure`
- ✅ Android app toegevoegd met package `com.bearsnacks.bearadventure`
- ✅ Firebase project: `bear-app-11252` (Bear App)

> **Note**: Firebase App Distribution is bewust **niet** geactiveerd in deze
> CI/CD setup. Staging gebeurt via TestFlight (iOS) en Play Internal
> Testing (Android). Indien later toch FAD gewenst, vereist dat extra
> GCP IAM setup (zie blocker B-3 in `SETUP-PROGRESS.md`).

### Code
- ✅ `flutterfire configure` gerunt met `bear-app-11252` + nieuwe bundle id
- ✅ Firebase config bestanden geüpdatet en consistent:
  - ✅ `bear_adventure_app/lib/firebase_options.dart`
  - ✅ `bear_adventure_app/android/app/google-services.json`
  - ✅ `bear_adventure_app/ios/Runner/GoogleService-Info.plist`
  - ✅ `bear_adventure_app/ios/firebase_app_id_file.json`

## GitHub repo configuratie

### Repo: `iodigital-com/bear-adventure-certificates` (match repo)
- ✅ Aangemaakt (private)
- ✅ Deploy key toegevoegd met write access
- ✅ Match initialiseerd: Distribution cert + AppStore profile gegenereerd

### Repo: `iodigital-com/bear-adventure`

#### Secrets

**Match (iOS) — kunnen NU al ingevoerd worden:**
- ✅ `MATCH_REPO_SSH_KEY`
- ✅ `MATCH_GIT_URL` = `git@github.com:iodigital-com/bear-adventure-certificates.git`
- ✅ `MATCH_PASSWORD`

**Apple (iOS) — kunnen NU al ingevoerd worden (Apple Team ID):**
- ✅ `APPLE_TEAM_ID` = `24NC63RDSP`
- ✅ `APPLE_ITC_TEAM_ID` = `24NC63RDSP`

**Apple (iOS) — wachten op blocker B-1:**
- 🟡 `APP_STORE_CONNECT_API_KEY_ID`
- 🟡 `APP_STORE_CONNECT_API_ISSUER_ID`
- 🟡 `APP_STORE_CONNECT_API_KEY_P8_BASE64`

**Firebase config (iOS) — kunnen NU al ingevoerd worden:**
- ✅ `IOS_GOOGLE_SERVICE_INFO_PLIST_BASE64`
- ✅ `IOS_FIREBASE_APP_ID_FILE_BASE64`

**Android signing — kunnen NU al ingevoerd worden:**
- ✅ `ANDROID_KEYSTORE_BASE64`
- ✅ `ANDROID_KEYSTORE_PASSWORD`
- ✅ `ANDROID_KEY_PASSWORD`
- ✅ `ANDROID_KEY_ALIAS` = `upload`

**Firebase config (Android) — kan NU al ingevoerd worden:**
- ✅ `ANDROID_GOOGLE_SERVICES_JSON_BASE64`

**Play Store — wachten op blocker B-2:**
- 🟡 `PLAY_STORE_JSON_KEY_BASE64`

#### Environments
- ✅ `staging` aangemaakt (branch policy: alleen `builds/staging`)
- ✅ `production` aangemaakt (branch policy: alleen `builds/production`)
- ⚠️ Required reviewers op `production` niet mogelijk: vereist GitHub Team plan (org `iodigital-com` heeft Free plan)

#### Branch protection
- ⚠️ Branch protection rules / rulesets niet mogelijk op huidige org plan
- Mitigation: environment branch policies (al actief) + alleen jij hebt write access

## Eenmalige developer-actie

- ✅ `bundle exec fastlane match appstore` lokaal gerunt — certs in match repo

## Security cleanup

- ⬜ **Bonzai API key geroteerd** (`.bonzai_key` zat in git history) — _door iO Digital admin_
- ⬜ Optioneel: `git filter-repo` om `.bonzai_key` uit history te wissen
