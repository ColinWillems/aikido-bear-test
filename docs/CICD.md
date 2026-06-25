# CI/CD Setup — BEAR Adventure

Dit document beschrijft het complete release proces voor de BEAR Adventure
Flutter app naar Google Play en de Apple App Store via GitHub Actions +
Fastlane. Lees dit van begin tot eind als je voor het eerst een omgeving
opzet — er zijn een aantal stappen die de klant zelf moet uitvoeren.

> **Bundle ID**: `com.bearsnacks.bearadventure`

## Inhoud

1. [Architectuur in vogelvlucht](#1-architectuur-in-vogelvlucht)
2. [Branch / lane mapping](#2-branch--lane-mapping)
3. [Eenmalige klant-setup](#3-eenmalige-klant-setup)
4. [GitHub secrets en variables](#4-github-secrets-en-variables)
5. [Lokaal builden / testen](#5-lokaal-builden--testen)
6. [Eerste release procedure](#6-eerste-release-procedure)
7. [Reguliere release procedure](#7-reguliere-release-procedure)
8. [Versioning](#8-versioning)
9. [Troubleshooting](#9-troubleshooting)
10. [Security notes](#10-security-notes)
11. [Open punten / technical debt](#11-open-punten--technical-debt)

---

## 1. Architectuur in vogelvlucht

```
┌────────────────────────┐
│ GitHub repo: main      │ ← reguliere development
└────────┬───────────────┘
         │ merge
         ▼
┌────────────────────────┐
│ builds/staging         │ ← push triggert:
└────────┬───────────────┘    • Android → Play Internal Testing track
         │ merge                • iOS    → TestFlight (internal)
         ▼
┌────────────────────────┐
│ builds/production      │ ← push triggert:
│                        │    • Android → Play Store production track
└────────────────────────┘    • iOS    → App Store Connect (upload only)
```

- **PR's** triggeren `pr-checks.yml` (format check, static analysis, tests
  — geen native compile builds, om CI minutes op het iO Digital free org plan
  te sparen). Native compile errors worden gedekt door de echte
  staging/production builds.
- iOS code signing draait via [fastlane match][match] tegen een **aparte
  private repo** met certificaten en provisioning profiles.
- Android code signing draait met een upload keystore die via secrets in CI
  wordt geinjecteerd.
- Versioning: `versionName` komt uit `pubspec.yaml`, `versionCode`/build
  number wordt door CI berekend (`GITHUB_RUN_NUMBER + 1000`).

[match]: https://docs.fastlane.tools/actions/match/

---

## 2. Branch / lane mapping

| Branch              | Wat gebeurt er Android                      | Wat gebeurt er iOS                          |
| ------------------- | ------------------------------------------- | ------------------------------------------- |
| `main`              | PR checks (geen upload)                     | PR checks (geen upload)                     |
| `builds/staging`    | Build AAB → **Play internal testing track** | Build IPA → **TestFlight (internal)**       |
| `builds/production` | Build AAB → **Play Store production track** | Build IPA → **App Store Connect (upload)**  |

App Store **submit-for-review** gebeurt **niet automatisch**. De klant
submit zelf vanuit App Store Connect na controle van de upload.

Play Store production releases worden **direct gepubliceerd** (status
`completed`) zodra de upload slaagt — pas op met directe pushes naar
`builds/production`.

Daarnaast bestaat er een **manueel-getriggerde** workflow:

- `ios-signing-validation.yml` — bouwt en signt een App Store IPA via
  fastlane match, **zonder** upload naar App Store Connect. Vereist geen
  App Store Connect API key, dus is bruikbaar als smoke test van de
  iOS signing pipeline ook voordat blocker B-1 is opgelost. Run via
  *Actions → iOS — Signing validation (no upload) → Run workflow*.

---

## 3. Eenmalige klant-setup

Deze stappen moet de klant éénmalig uitvoeren samen met een developer. Loop
ze in volgorde af.

### 3.1 Apple Developer Portal — App ID + capabilities

1. Login op <https://developer.apple.com/account/> met klant account.
2. Ga naar **Certificates, Identifiers & Profiles → Identifiers → +**.
3. Kies **App IDs → App** → continue.
4. Description: `BEAR Adventure`.
5. Bundle ID (Explicit): `com.bearsnacks.bearadventure`.
6. Capabilities: vink minstens aan:
   - **Push Notifications** (voor Firebase Messaging)
   - **Associated Domains** (voor deeplinks)
   - **App Groups** *(alleen indien gebruikt)*
7. Submit. **Bewaar de Team ID** (10 chars, vb. `ABCDE12345`) — deze komt in
   `APPLE_TEAM_ID` secret.

### 3.2 App Store Connect — App aanmaken

1. Login op <https://appstoreconnect.apple.com/>.
2. **My Apps → +** → New App.
3. Velden:
   - Platforms: iOS
   - Name: `BEAR Adventure`
   - Primary language: Nederlands (of Engels, naar wens klant)
   - Bundle ID: kies `com.bearsnacks.bearadventure` (verschijnt in dropdown
     na step 3.1)
   - SKU: vrij te kiezen, vb. `BEARADVENTURE001`
   - User access: Full access
4. Vul minimaal in onder *App Information* (kan later):
   - Privacy policy URL
   - Category
5. **Bewaar de App ID** (te zien in de URL: `appstoreconnect.apple.com/apps/<APP_ID>/...`).

### 3.3 App Store Connect — API key voor CI

1. Login op <https://appstoreconnect.apple.com/access/api>.
2. **Keys → Team Keys → +**.
3. Name: `GitHub Actions CI`
4. Access: **App Manager** (volstaat voor TestFlight + uploads).
5. Download het `.p8` bestand. **Belangrijk**: dit bestand is maar 1× te
   downloaden.
6. Bewaar:
   - **Key ID** (10 chars)
   - **Issuer ID** (UUID, bovenaan op de pagina)
   - Het `.p8` bestand zelf (lokaal veilig opslaan)

### 3.4 Match repo voor iOS certificaten

1. Maak een **nieuwe private GitHub repo** aan: bv.
   `iodigital-com/bear-adventure-certificates`.
2. Initialiseer leeg (geen README/license).
3. Genereer een dedicated **deploy key** voor deze repo:

   ```bash
   ssh-keygen -t ed25519 -f bear-adventure-match -N "" -C "match deploy key"
   ```

4. In de match repo: **Settings → Deploy keys → Add deploy key**.
   - Title: `Fastlane match (read/write)`
   - Key: inhoud van `bear-adventure-match.pub`
   - **Allow write access**: ✅
5. De **private key** (`bear-adventure-match`) komt in `MATCH_REPO_SSH_KEY`
   secret van de bear-adventure repo.
6. Bedenk een **strong password** voor match encryption — komt in
   `MATCH_PASSWORD`.

### 3.5 Match initialiseren (eenmalig, lokaal door developer)

> Voer dit uit met een Mac waarop Xcode geïnstalleerd is, en met de Apple
> account die toegang heeft tot het Apple Developer team van de klant.

```bash
cd bear_adventure_app
bundle install
cd ios

# Eénmalig (interactief): cert + profile aanmaken in match repo
export MATCH_GIT_URL=git@github.com:iodigital-com/bear-adventure-certificates.git
export MATCH_PASSWORD=<gekozen-password>
export APPLE_TEAM_ID=<klant-team-id>
export FASTLANE_APPLE_ID=<apple-account-email>

bundle exec fastlane match appstore
```

Match commit nu de gegenereerde certs/profiles in de private repo. Vanaf
nu kan CI ze ophalen via `match(readonly: true)`.

### 3.6 Google Play Console — App aanmaken

1. Login op <https://play.google.com/console/>.
2. **Create app**.
3. Velden:
   - App name: `BEAR Adventure`
   - Default language
   - App or game: App
   - Free or paid: Free (aanpassen indien klant wilt)
   - Akkoord checkboxes
4. Onder **Setup**:
   - App access
   - Ads
   - Content rating
   - Target audience
   - Data safety
   - Privacy policy
5. **Belangrijk**: vul al deze items in vóórdat je een productie release
   probeert te uploaden. Anders blokkeert Play Console.

### 3.7 Google Play — Service account voor CI

1. Open <https://console.cloud.google.com/> en selecteer het Firebase project
   (dat is automatisch ook een GCP project).
2. **IAM & Admin → Service Accounts → Create Service Account**.
3. Name: `play-publisher`
4. Skip role assignment in GCP — we doen dat in Play Console.
5. Bij de aangemaakte service account: **Keys → Add Key → JSON**.
6. Download het JSON bestand.
7. In Play Console: **Setup → API access**.
8. Klik **Link** voor de juiste GCP project, daarna **Grant access** op het
   service account.
9. Permissions:
   - **Releases**: Manage production releases ✅
   - **Releases**: Manage testing track releases ✅
   - **App access**: View app information ✅
10. Save.

### 3.8 Android — Upload keystore

> Slechts éénmalig per app. Dit keystore signt alle uploads naar Play
> Console. Bewaar **veilig** — als je 'm verliest moet de klant Play App
> Signing reset aanvragen bij Google (kan tot 48 uur duren).

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -dname "CN=BearSnacks, OU=Mobile, O=BearSnacks, L=City, S=State, C=BE"
```

Bewaar:

- Het `.jks` bestand zelf (komt in `ANDROID_KEYSTORE_BASE64`)
- Het keystore password (komt in `ANDROID_KEYSTORE_PASSWORD`)
- Het key password (komt in `ANDROID_KEY_PASSWORD`, mag identiek zijn aan
  keystore password)
- De alias (`upload`, komt in `ANDROID_KEY_ALIAS`)

### 3.9 Firebase project — apps + tester groep

1. Login op <https://console.firebase.google.com/> en selecteer het klant
   project.
2. **Project settings → Your apps → Add app**:
   - Voor **iOS**: bundle ID `com.bearsnacks.bearadventure`. Download
     `GoogleService-Info.plist`.
   - Voor **Android**: package name `com.bearsnacks.bearadventure`. Download
     `google-services.json`.

> **Note**: Firebase App Distribution is **niet** actief in de huidige
> CI/CD setup. Staging builds gaan via TestFlight (iOS) en Play Internal
> Testing track (Android). Als App Distribution later toegevoegd moet
> worden, vereist dat extra IAM setup en een aparte service account.

### 3.10 Firebase config in de codebase regenereren

> **Belangrijk**: nu moet de klant Firebase configuratiebestanden
> regenereren met de nieuwe bundle id en het nieuwe project. De huidige
> bestanden in de repo wijzen nog naar het oude iO Digital project.

Met FlutterFire CLI (eenmalig):

```bash
cd bear_adventure_app
dart pub global activate flutterfire_cli
flutterfire configure \
  --project=<klant-firebase-project-id> \
  --platforms=android,ios \
  --android-package-name=com.bearsnacks.bearadventure \
  --ios-bundle-id=com.bearsnacks.bearadventure
```

Dit overschrijft:

- `bear_adventure_app/lib/firebase_options.dart`
- `bear_adventure_app/android/app/google-services.json`
- `bear_adventure_app/ios/Runner/GoogleService-Info.plist`
- `bear_adventure_app/ios/firebase_app_id_file.json`

**Commit deze 4 bestanden naar git** zodat lokale builds en CI dezelfde
config gebruiken.

> Ook in CI willen we deze bestanden uit secrets schrijven (zie workflows),
> zodat we *defense in depth* hebben en een ander Firebase project per
> environment kunnen gebruiken in de toekomst.

---

## 4. GitHub secrets en variables

Ga naar `Settings → Secrets and variables → Actions` van deze repo.

### Repository secrets — Android

| Secret name                          | Inhoud / hoe te genereren                                                |
| ------------------------------------ | ------------------------------------------------------------------------ |
| `ANDROID_KEYSTORE_BASE64`            | `base64 -i upload-keystore.jks` (op macOS: `-i` flag verplicht)          |
| `ANDROID_KEYSTORE_PASSWORD`          | Het keystore password gekozen in stap 3.8                                |
| `ANDROID_KEY_PASSWORD`               | Het key password gekozen in stap 3.8                                     |
| `ANDROID_KEY_ALIAS`                  | `upload` (of de alias gekozen in stap 3.8)                               |
| `ANDROID_GOOGLE_SERVICES_JSON_BASE64`| `base64 -i google-services.json` (van het klant Firebase project)        |
| `PLAY_STORE_JSON_KEY_BASE64`         | `base64 -i play-store-key.json` (van stap 3.7)                           |

### Repository secrets — iOS

| Secret name                              | Inhoud                                                                |
| ---------------------------------------- | --------------------------------------------------------------------- |
| `MATCH_REPO_SSH_KEY`                     | De **private** SSH deploy key uit stap 3.4 (volledige inhoud)         |
| `MATCH_GIT_URL`                          | `git@github.com:iodigital-com/bear-adventure-certificates.git`        |
| `MATCH_PASSWORD`                         | Het password gekozen in stap 3.4                                      |
| `APPLE_TEAM_ID`                          | 10-char Team ID uit stap 3.1                                          |
| `APPLE_ITC_TEAM_ID`                      | App Store Connect team ID (vaak hetzelfde als APPLE_TEAM_ID)          |
| `APP_STORE_CONNECT_API_KEY_ID`           | Uit stap 3.3                                                          |
| `APP_STORE_CONNECT_API_ISSUER_ID`        | Uit stap 3.3                                                          |
| `APP_STORE_CONNECT_API_KEY_P8_BASE64`    | `base64 -i AuthKey_XXXXXX.p8`                                         |
| `IOS_GOOGLE_SERVICE_INFO_PLIST_BASE64`   | `base64 -i GoogleService-Info.plist`                                  |
| `IOS_FIREBASE_APP_ID_FILE_BASE64`        | `base64 -i firebase_app_id_file.json`                                 |

### Repository variables (niet-secret)

Geen variables vereist op dit moment.

### GitHub Environments

De workflows verwachten 2 environments: `staging` en `production`.

Aanmaken: `Settings → Environments → New environment`.

Aanbevolen voor `production`:
- **Required reviewers**: minstens 1 reviewer (jij of klant) moet handmatig
  approven voor de workflow start.
- **Deployment branches**: alleen `builds/production` toestaan.

Voor `staging`: geen required reviewers (snelle iteratie), wel beperken tot
`builds/staging` branch.

### Generieke base64 commando's

| Doel                     | macOS / Linux                              |
| ------------------------ | ------------------------------------------ |
| Encode bestand → base64  | `base64 -i <bestand> \| pbcopy` (macOS)    |
| Encode bestand → base64  | `base64 -w 0 <bestand>` (Linux)            |
| Decode base64 → bestand  | `echo "<base64>" \| base64 --decode > out` |

---

## 5. Lokaal builden / testen

### Tooling versies

```
flutter 3.41.1
ruby 3.3
java 21
xcode 16.x
```

Gebruik [asdf](https://asdf-vm.com/) of [mise](https://mise.jdx.dev/) met
het meegeleverde `.tool-versions` bestand.

### Initial setup

```bash
cd bear_adventure_app
flutter pub get
bundle install   # installeert fastlane + cocoapods gems
cd ios && pod install --repo-update && cd ..
```

### Lokaal Android release build

```bash
# Plaats key.properties + upload-keystore.jks in android/ (gitignored)
cd bear_adventure_app
flutter build appbundle --release
```

### Lokaal iOS build (zonder uploaden)

In Xcode:
1. Open `ios/Runner.xcworkspace`
2. Selecteer Runner target → Signing & Capabilities → kies team
3. Build & Run

Via fastlane (vereist match credentials in env):

```bash
cd bear_adventure_app/ios
bundle exec fastlane ios setup_signing  # haal certs op
# Build via flutter:
cd .. && flutter build ipa --release
```

### Lokale fastlane lanes uitvoeren

Wel nodig: alle env variabelen die normaal CI levert. Gebruik een lokaal
`.env` bestand (gitignored):

```bash
# bear_adventure_app/.env (NIET commiten)
MATCH_GIT_URL=git@github.com:iodigital-com/bear-adventure-certificates.git
MATCH_PASSWORD=...
APPLE_TEAM_ID=...
APP_STORE_CONNECT_API_KEY_ID=...
APP_STORE_CONNECT_API_ISSUER_ID=...
APP_STORE_CONNECT_API_KEY_PATH=/Users/you/path/AuthKey_XXXX.p8
```

Gebruiken:

```bash
cd bear_adventure_app/ios
set -a && source ../.env && set +a
bundle exec fastlane ios beta
```

---

## 6. Eerste release procedure

### 6.1 Eerste Android release naar Play Store (handmatig vereist)

**Google Play Console weigert API uploads tot er minstens 1 release is via
de UI.** Daarom moet de eerste keer handmatig:

1. Lokaal: `flutter build appbundle --release` met de upload keystore.
2. Play Console → **Internal testing → Create new release**.
3. Upload de `.aab`. Vul release notes in. Save → Review release →
   Start rollout.
4. Daarna kan CI alle volgende uploads doen.

### 6.2 Eerste iOS build via match

Eénmalig: stap 3.5 (match initialiseren) uitvoeren.

Daarna: push naar `builds/staging` → eerste TestFlight upload via CI.

### 6.3 Eerste TestFlight build naar App Store Connect

1. Push naar `builds/staging`.
2. Wacht ~15 min tot Apple de build verwerkt.
3. In App Store Connect → TestFlight: build verschijnt in *Internal Testing*.
4. Voeg internal testers toe (max 100 Apple ID's binnen je team).
5. Voor **externe testers** (na approval): voeg builds handmatig toe aan
   externe testgroep, vraag Beta App Review aan.

### 6.4 Eerste App Store productie release

1. Push naar `builds/production`.
2. CI uploadt IPA naar App Store Connect.
3. **Klant** logt in op App Store Connect:
   - Vult metadata, screenshots, beschrijving, keywords in
   - Selecteert de geuploade build
   - Klikt **Submit for Review**
4. Apple review duurt 24-48u.

---

## 7. Reguliere release procedure

### Staging release

```bash
git checkout main
git pull
git checkout builds/staging
git merge --ff-only main   # of: git reset --hard main
git push origin builds/staging
```

CI voert automatisch uit:
- `android-staging.yml` → AAB naar Play Console internal testing track
- `ios-staging.yml` → IPA in TestFlight (internal testers)

Testers krijgen automatische push notificaties via de Play Store / TestFlight
apps wanneer een nieuwe build beschikbaar is.

### Production release

```bash
git checkout builds/production
git merge --ff-only builds/staging
git push origin builds/production
```

CI voert automatisch uit:
- `android-production.yml` → AAB in Play Store production track (live!)
- `ios-production.yml` → IPA in App Store Connect

> **Voor iOS**: na de upload moet de klant zelf in App Store Connect klikken
> op **Submit for Review** voor de nieuwe build.

### Manueel triggeren

Elke workflow heeft `workflow_dispatch` enabled met een optionele
`release_notes` parameter. Trigger via:

`Actions → <workflow naam> → Run workflow → kies branch → optioneel notes`.

---

## 8. Versioning

**`versionName`** (`5.0.2` etc.) komt uit `pubspec.yaml`:

```yaml
version: 5.0.2+52
        ^^^^^^^   ← versionName / CFBundleShortVersionString
              ^^  ← versionCode / CFBundleVersion (genegeerd in CI)
```

- Bump de major/minor/patch handmatig bij feature- of breaking releases.
- Het build number na de `+` wordt **genegeerd** door CI; CI gebruikt:

  ```
  versionCode = GITHUB_RUN_NUMBER + 1000
  ```

  De `+1000` offset zorgt dat we niet conflicteren met de huidige Play
  Store waarde (52). Pas dit aan in de Fastfile als je een hogere
  baseline nodig hebt.

- Voor App Store Connect gebruikt fastlane standaard ook `GITHUB_RUN_NUMBER + 1000`.
  Apple staat herbruik van build numbers binnen één versionName niet toe; bij
  conflict kun je de offset verhogen via `BUILD_NUMBER` env var bij
  workflow dispatch.

---

## 9. Troubleshooting

### Match: "could not find code signing identity"

```
[!] Could not install WWDR certificate
```

Match probeert het Apple WWDR cert te installeren. Op CI lost
`setup_ci` (dat we in de Fastfile aanroepen) dit op. Check of `before_all`
hook draait.

### Match: "Permission denied (publickey)"

De `MATCH_REPO_SSH_KEY` is niet correct ingesteld of de deploy key heeft
geen schrijfrechten. Verifieer:

```bash
ssh -T git@github.com
# Moet "Hi <repo-name>! You've successfully authenticated" tonen.
```

### Play Store: "Package not found"

Eerste handmatige upload (stap 6.1) is nog niet gedaan, of de service
account heeft geen permissions op deze app. Check Play Console → Setup →
API access.

### Play Store: "Version code <X> already used"

Dit gebeurt als je dezelfde build twee keer probeert te uploaden. Verhoog
de offset in de Fastfile of trigger een nieuwe workflow run (nieuwe
`GITHUB_RUN_NUMBER`).

### TestFlight: "Invalid Bundle. The bundle does not contain a valid Mach-O binary"

Bijna altijd een Pods cache probleem. Lokaal:

```bash
cd bear_adventure_app/ios
rm -rf Pods Podfile.lock
pod install --repo-update
```

In CI: temporarily disable de Pods cache step (commenteer uit) en run
opnieuw.

### iOS: "No matching profiles found for bundle id"

Het ad-hoc of appstore profile bestaat niet in de match repo. Run lokaal:

```bash
cd bear_adventure_app/ios
bundle exec fastlane match appstore --force_for_new_devices
# of
bundle exec fastlane match adhoc --force_for_new_devices
```

### iOS build error op `dyld[]: Library not loaded` voor Firebase

`GoogleService-Info.plist` ontbreekt in het build bundel of wijst naar het
verkeerde Firebase project. Check stap 3.10.

---

## 10. Security notes

### ⚠️ Reeds gecommiteerde secrets in git history

Dit was de stand vóór deze CI/CD setup:

| Bestand                             | Status                              |
| ----------------------------------- | ----------------------------------- |
| `.bonzai_key`                       | API key voor LiteLLM proxy — **moet geroteerd worden** |
| `bear_adventure_app/android/key.properties.save` | Placeholder credentials (test123) — geen lekkage |
| Firebase configs (oude project)     | Public anyway (Firebase API keys zijn niet geheim) |

**Te doen door iemand met admin access:**

1. **Roteer de Bonzai API key** bij iO Digital LiteLLM proxy.
2. Optioneel: `git filter-repo` om `.bonzai_key` te scrubben uit history.
   (Niet kritiek omdat de key na rotatie waardeloos is.)

### Firebase API keys zijn niet "secret"

Firebase web/mobile API keys zijn ontworpen om public te zijn. Ze
identificeren je project, maar geven geen toegang tot data — dat regelt
Firebase Security Rules. Daarom committen we `firebase_options.dart` en
`google-services.json` gewoon naar de repo.

### Wat WEL geheim is

- Service account JSONs (Play Store, Firebase Admin)
- App Store Connect API key (.p8)
- Match repo SSH key + match password
- Upload keystore + passwords

Allemaal in GitHub Secrets, niet in de repo.

---

## 11. Open punten / technical debt

Niet meegenomen in deze CI/CD iteratie, opnemen als aparte tickets:

| Item | Impact |
|------|--------|
| **Firebase Dynamic Links sunset (Aug 2025)** | App gebruikt FDL voor deeplinks (`client.bearadventure.app`). Migreren naar Firebase Hosting + `apple-app-site-association` + Android App Links. |
| **`client.bearadventure.app` domein eigenaarschap** | Verifieer of klant dit domein bezit. Zo niet: nieuw domein, AASA file, DNS configureren. |
| **Git deps zonder pin** (`camerawesome`, `decorated_text`, `open_filex`) | Pinnen op specifieke commit/tag voor reproduceerbare builds. |
| **`local.properties` based Android versioning** | Niet ideaal; we overschrijven nu via flutter build flags maar de gradle logic zou cleaner kunnen. |
| **Composite GitHub Action voor setup steps** | Veel duplicate setup steps tussen workflows; refactoren naar `.github/actions/setup-flutter/action.yml`. |
| **Branch protection + CODEOWNERS** | Configureren in `Settings → Branches` voor `main`, `builds/staging`, `builds/production`. |
| **Auto-submit voor App Store** | Optie om later toe te voegen via `submit_for_review: true` als klant comfortabel is met automatisering. |
| **Crashlytics dSYM upload** | Werkt al via build phase; verifieer dat dSYMs aankomen na eerste TestFlight build. |
