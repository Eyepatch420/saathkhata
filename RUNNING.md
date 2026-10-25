# Running SaathKhata

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ≥ 3.11.5 |
| Dart SDK | ≥ 3.0.0 (bundled with Flutter) |
| Android Studio / Xcode | latest stable |
| Android SDK | API 21+ |
| Xcode | 14+ (for iOS) |

---

## 1. Environment Setup (required before first run)

The app uses a `.env` file for API keys. This file is **not committed** to git.

```bash
# Create the .env file in the project root
cp .env.example .env        # if an example file exists, OR
touch .env                  # create from scratch
```

Open `.env` and add:

```env
LOCATIONIQ_API_KEY=pk.89bc3f5741b83c2e87bc594c481f9432
```

> OTP delivery is backend-only. No UDO (or any other SMS provider) credentials
> belong in this app — `.env` is bundled as a Flutter asset, so everything in it
> ships inside the built binary. Set `OTP_PROVIDER` and the provider credentials
> in `saath_khata_backend` instead; see `docs/UDO_OTP_API.md` for the API
> reference and the backend's `tools/check-otp-key.sh` to validate a UDO key
> without sending a message.

> The `.env` file is bundled as a Flutter asset at build time.
> Never commit it — it is already in `.gitignore`.

---

## 2. Install dependencies

```bash
flutter pub get
```

---

## 3. Running on Android

### Debug (hot-reload enabled)
```bash
# List connected devices first
flutter devices

# Run on a specific device
flutter run -d <device-id>

# Run on any available Android device
flutter run
```

### Release (optimised, no debug info)
```bash
flutter run --release
```

### Build APK (for manual install / distribution)
```bash
# Debug APK
flutter build apk --debug

# Release APK (split per ABI — smaller files)
flutter build apk --release --split-per-abi

# Universal release APK
flutter build apk --release
```
Output is at `build/app/outputs/flutter-apk/`.

### Build App Bundle (Google Play)
```bash
flutter build appbundle --release
```
Output is at `build/app/outputs/bundle/release/app-release.aab`.

---

## 4. Running on iOS

> Requires macOS with Xcode installed and a valid Apple developer account for physical devices.

### Simulator (debug)
```bash
# List available simulators
open -a Simulator
flutter devices

flutter run -d <simulator-id>
```

### Physical device (debug)
```bash
# Connect iPhone via USB, trust the Mac on the device, then:
flutter run -d <device-id>
```

### Release on physical device
```bash
flutter run --release -d <device-id>
```

### Build IPA (Ad Hoc / App Store)
```bash
flutter build ipa --release
```
Then open `build/ios/archive/Runner.xcarchive` in Xcode to distribute.

---

## 5. Running on other platforms

```bash
# macOS
flutter run -d macos

# Web
flutter run -d chrome

# Linux
flutter run -d linux

# Windows
flutter run -d windows
```

---

## 6. Useful flags

| Flag | Effect |
|------|--------|
| `--debug` | Default; enables hot-reload & debug overlay |
| `--profile` | Performance profiling; no debug overlay |
| `--release` | Fully optimised; no hot-reload |
| `--flavor <name>` | Use a build flavour (if configured) |
| `--dart-define KEY=VALUE` | Inject compile-time variables |
| `-v` | Verbose output (useful for diagnosing build errors) |

---

## 7. LocationIQ API key notes

| Feature | Endpoint used |
|---------|--------------|
| Map tiles | `tiles.locationiq.com/v3/streets/r/{z}/{x}/{y}.png` |
| Address autocomplete | `us1.locationiq.com/v1/autocomplete` |
| Reverse geocoding | `us1.locationiq.com/v1/reverse` |

All calls use the key in `.env` loaded at startup via `flutter_dotenv`.
If the key is missing the map will show blank tiles and search will return no results.

---

## 8. Troubleshooting

**`Bad state: No element` / dotenv error on startup**
→ Make sure `.env` exists in the project root and contains `LOCATIONIQ_API_KEY`.

**Map shows blank tiles**
→ Verify the API key is correct and the device has internet access.

**Location permission denied on Android emulator**
→ Open *Settings → Apps → SaathKhata → Permissions → Location* and grant it.

**iOS build fails with codesign error**
→ Open `ios/Runner.xcworkspace` in Xcode, set your team under *Signing & Capabilities*, then re-run.
