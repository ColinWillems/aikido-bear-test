# BEAR Adventure

Flutter app voor klant **BearSnacks**. Verspreid via Google Play en de
Apple App Store.

## App identifiers

- **Bundle ID / package name**: `com.bearsnacks.bearadventure`
- **Versie**: zie `bear_adventure_app/pubspec.yaml` (`version:` veld)

## Repository structuur

```
bear-adventure/
├── .github/workflows/      ← CI/CD pipelines (zie docs/CICD.md)
├── bear_adventure_app/     ← Flutter app (entry point)
│   ├── lib/                 main.dart en feature code
│   ├── android/             Android specific (incl. fastlane)
│   ├── ios/                 iOS specific (incl. fastlane)
│   └── pubspec.yaml
├── packages/               ← Lokale Dart packages
│   ├── bear_necessities/
│   ├── firebase_app_utils/
│   ├── flutter_app_utils/
│   └── gamification/
├── fir-functions/          ← Firebase Cloud Functions
├── scripts/                ← Translatie / build scripts
└── docs/                   ← Documentatie (CI/CD, runbooks)
```

## Lokaal aan de slag

### Vereisten

```
flutter 3.41.1
ruby 3.3
java 21
xcode 16.x (alleen voor iOS)
```

Aanbeveling: gebruik [mise](https://mise.jdx.dev/) of
[asdf](https://asdf-vm.com/) met het meegeleverde `.tool-versions`.

### Setup

```bash
cd bear_adventure_app
flutter pub get
bundle install
cd ios && pod install --repo-update
```

### Run

```bash
cd bear_adventure_app
flutter run
```

## Releases

Volledige uitleg: [`docs/CICD.md`](docs/CICD.md).
Setup checklist: [`docs/CICD-CHECKLIST.md`](docs/CICD-CHECKLIST.md).

Korte samenvatting:

| Branch              | Trigger                                                   |
| ------------------- | --------------------------------------------------------- |
| PR naar `main`      | Format + analyze + tests (no native build)                |
| `builds/staging`    | Android → Firebase App Distribution; iOS → TestFlight     |
| `builds/production` | Android → Play production; iOS → App Store Connect (upload) |

App Store **submit-for-review** gebeurt **handmatig** door de klant in
App Store Connect na elke productie upload.