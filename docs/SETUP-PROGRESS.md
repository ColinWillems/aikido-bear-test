# Setup progress — BEAR Adventure CI/CD

Live tracking van de eenmalige setup. Zie [`CICD.md`](./CICD.md) voor de
volledige uitleg en [`CICD-CHECKLIST.md`](./CICD-CHECKLIST.md) voor de
formele afvink-lijst.

> Laatst bijgewerkt: 2026-05-13

---

## Verzamelde IDs en waardes

> Deze tabel groeit naarmate de setup vordert. **Geheime waardes (passwords,
> .p8 files, JSON keys) staan NIET hier — alleen non-secret IDs.**

### Apple

| Item | Waarde | GitHub secret naam |
|---|---|---|
| Apple Team ID | `24NC63RDSP` | `APPLE_TEAM_ID` |
| Apple ITC Team ID | (zelfde als team ID) | `APPLE_ITC_TEAM_ID` |
| Apple Team naam | Lotus Bakeries Corporate | — |
| App ID (Bundle ID) | `com.bearsnacks.bearadventure` | (niet als secret, in code) |
| App Store Connect numerieke App ID | `6768928418` | (handig voor referentie) |
| App Store name | BEAR — Adventure | (storefront only) |
| Bundle Display Name | BEAR Adventure | (homescreen, in `Info.plist`) |
| Company / Seller | Lotus Bakeries | (App Store listing) |
| SKU | BEARADVENTURE | (intern App Store Connect) |
| Account Holder | Sofie De Letter (`sofie.deletter@lotusbakeries.com`) | — |
| App Store Connect API Key ID | _(nog niet aangemaakt — blocker)_ | `APP_STORE_CONNECT_API_KEY_ID` |
| App Store Connect API Issuer ID | _(nog niet aangemaakt — blocker)_ | `APP_STORE_CONNECT_API_ISSUER_ID` |

### Google / Firebase

| Item | Waarde | GitHub secret naam |
|---|---|---|
| Firebase project ID | `bear-app-11252` | (in google-services.json) |
| Firebase project naam | Bear App | — |
| Android package name | `com.bearsnacks.bearadventure` | (niet als secret, in code) |
| Firebase Android App ID | _(in google-services.json — extract na verificatie)_ | `FIREBASE_APP_ID_ANDROID` |
| Firebase iOS App ID | _(in firebase_app_id_file.json)_ | `FIREBASE_APP_ID_IOS` |
| Play Console account | ICT Lotus Bakeries (org account) | — |
| Play Console account ID | `6716310778976865820` | — |
| Play Console app | _(blocked B-2)_ | — |
| Tester groep | `internal-testers` | — |

### GitHub

| Item | Waarde |
|---|---|
| App repo | `iodigital-com/bear-adventure` |
| Match repo | `iodigital-com/bear-adventure-certificates` _(nog niet aangemaakt)_ |

---

## Voortgang per fase

### ✅ Fase A — Apple Developer Portal
- [x] Login + team-keuze (Lotus Bakeries Corporate)
- [x] App ID `com.bearsnacks.bearadventure` geregistreerd
- [x] Capabilities: Push Notifications, Associated Domains, In-App Purchase

### 🟡 Fase B — App Store Connect (deels klaar)
- [x] App aangemaakt: BEAR — Adventure (App ID `6768928418`)
- [ ] **🚧 BLOCKER**: API access aanvragen (alleen Account Holder kan dit)
- [ ] API Key aanmaken (na unblock)
- [ ] `.p8` file downloaden + Key ID + Issuer ID noteren

### ⬜ Fase C — Match repo (GitHub)
- [ ] Repo `bear-adventure-certificates` aanmaken (private)
- [ ] SSH deploy key genereren
- [ ] Deploy key toevoegen aan repo (write access)
- [ ] Match password kiezen
- [ ] Lokaal `fastlane match appstore` runnen → certs + profile in repo

### ⬜ Fase D — Google Play
- [ ] **🚧 BLOCKED B-2**: Account Owner moet Play App Signing T&C accepteren + Samuel rol geven
- [ ] App aanmaken in Play Console (`com.bearsnacks.bearadventure`) — package name is **available** ✅
- [ ] Privacy policy URL: `https://bearsnacks.com/en-us/disclaimer`
- [ ] Content rating questionnaire invullen
- [ ] Target audience instellen
- [ ] Data safety form
- [ ] Service account aanmaken in GCP
- [ ] JSON key downloaden
- [ ] Service account permissions in Play Console
- [ ] Eerste handmatige internal release upload

### ⬜ Fase E — Android signing
- [ ] Upload keystore genereren (`keytool`)
- [ ] Keystore + passwords veilig bewaren
- [ ] Base64 encoderen voor GitHub secrets

### ✅ Fase F — Firebase
- [x] Firebase apps geregistreerd in `bear-app-11252` (via `flutterfire configure`)
- [x] Android `google-services.json` correct
- [x] iOS `GoogleService-Info.plist` correct
- [x] iOS `firebase_app_id_file.json` correct (handmatig geüpdatet na xcodeproj fix)
- [~] ~~App Distribution activeren~~ — gedropt; staging gaat via TestFlight + Play Internal Testing
- [~] ~~Tester groep~~ — niet meer nodig (TestFlight/Play hebben eigen tester management)
- [~] ~~Service account voor App Distribution~~ — niet meer nodig (zie blocker B-3)

### ⬜ Fase G — GitHub repo configuratie
- [x] 12 niet-blocked secrets ingevoerd via `gh` CLI
- [ ] 4 nog ontbrekende secrets (na blockers B-1 en B-2):
  - `APP_STORE_CONNECT_API_KEY_ID` (B-1)
  - `APP_STORE_CONNECT_API_ISSUER_ID` (B-1)
  - `APP_STORE_CONNECT_API_KEY_P8_BASE64` (B-1)
  - `PLAY_STORE_JSON_KEY_BASE64` (B-2)
- [x] Environments aangemaakt: `staging` + `production` met branch policies
- [ ] ~~Required reviewers op production~~ — niet mogelijk op iO Digital free org plan
- [ ] ~~Branch protection rules~~ — niet mogelijk op iO Digital free org plan

### ⬜ Fase H — Eerste releases
- [ ] Match initialiseren: `fastlane match appstore` (lokaal, eenmalig)
- [ ] Eerste handmatige Play Store internal release
- [ ] Push naar `builds/staging` → smoke test pipelines

---

## 🚧 Actieve blockers

### B-1: App Store Connect API Access

**Wat**: Apple eist dat de Account Holder eenmalig API access activeert.

**Wie**: Sofie De Letter (`sofie.deletter@lotusbakeries.com`)

**Hoe lang**: ~2 minuten voor Sofie

**Stappen voor Sofie**:
1. Login op <https://appstoreconnect.apple.com/access/integrations/api>
2. Klik op de blauwe **Request Access** knop
3. Akkoord gaan met de App Store Connect API agreement

**Status**: verzoek verstuurd op _2026-05-13_ — wachtend op Sofie

**Impact**: blokkeert iOS CI workflows (TestFlight + App Store upload).
Match initialiseren werkt al wel zonder deze key (gebruikt Apple ID auth
lokaal). Pas vanaf Fase H zit de echte impact.

### B-2: Google Play Console permissions + Play App Signing T&C

**Wat**: Het Google Play Console account `ICT Lotus Bakeries` (Account ID
`6716310778976865820`) is corporate-managed. Samuel heeft beperkte toegang:
kan een app aanmaken-formulier wel zien, maar de **Play App Signing Terms
of Service** checkbox is geblokkeerd ("Contact your developer account
owner or administrator"). Ook Users and permissions, account details
zijn niet zichtbaar.

**Wie**: Account Owner van de Play Console (onbekend — IT Lotus Bakeries
moet dit identificeren)

**Hoe lang**: ~5 minuten als de juiste persoon wordt bereikt

**Stappen voor Account Owner**:
1. Login op <https://play.google.com/console/u/0/developers/6716310778976865820>
2. Bij het maken van de eerste app (of via Settings → App signing):
   accepteer de **Play App Signing Terms of Service**
3. Ga naar **Users and permissions** en geef Samuel
   (`samuel.joos@iodigital.com`) één van deze rollen:
   - **Admin** (eenvoudigst), OF
   - Custom rol met minimaal:
     - "Create, edit, and delete draft apps" ✅
     - "Manage testing track releases" ✅
     - "Manage production releases" ✅
     - "Manage store listings" ✅
     - "View app information and download bulk reports" ✅

**Status**: bericht verzonden op _2026-05-13_ — wachtend op IT Lotus Bakeries

**Impact**: blokkeert hele Android-track (kan geen app aanmaken, geen
service account toegang verlenen). Geen progressie mogelijk op Fase D, E,
of de Android delen van Fase G + H tot dit opgelost is.

### ~~B-3: GCP IAM permissions + Service Account Key creatie geblokkeerd~~ (RESOLVED via scope reduction)

**Wat was**: Twee gerelateerde GCP issues:
1. Samuel had geen `resourcemanager.projects.setIamPolicy` rol → kon geen
   IAM rollen toekennen
2. Org Policy `iam.disableServiceAccountKeyCreation` blokkeerde JSON keys

**Hoe opgelost**: Firebase App Distribution is **uit scope** gehaald van de
CI/CD setup. Staging gaat via TestFlight (iOS) + Play Internal Testing
(Android), beide native zonder GCP service account dependency.

**Indien later toch nodig**: Workload Identity Federation opzetten of een
project-specifieke org policy uitzondering aanvragen.

---

## Niet-blocking workstreams die parallel doorlopen

Tijdens wachten op B-1 kunnen we met deze stappen doorgaan (Android-track
heeft geen Apple dependency):

1. **Match repo** aanmaken op GitHub (Fase C)
2. **Google Play** app aanmaken + service account (Fase D)
3. **Android keystore** genereren (Fase E)
4. **Firebase App Distribution** activeren (Fase F afronden)
5. **GitHub secrets** voor Android + Firebase invoeren (Fase G deels)
