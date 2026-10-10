# Android signing

Application ID: `com.orientmark.sportsman`.
Debug application ID: `com.orientmark.sportsman.debug`.
Debug and release can be installed together and have separate application data and settings.
Launcher name: `OrientMark Athlete` by default, `OrientMark — Спортсмен` for Russian.

Debug builds use the standard Android debug key (`flutter run` or `flutter build apk --debug`).
Debug launcher names start with `[DEBUG]` in all supported languages, and the launcher icon has a red DEBUG badge.
These resources live in `app/src/debug` and are excluded from release builds.
Release builds use this application's private key via `android/key.properties`.
Copy `key.properties.example` to `key.properties` when configuring another computer.
The keystore and passwords are local secrets excluded from Git. Never share them with APK recipients.
Back up both `key.properties` and `keystore/sportsman-release.jks` securely outside this computer.
Direct APK updates must retain the same signing key and application ID and use a higher version code.
Each variant must be updated using its own signing key and application ID.
Older debug builds that used the release application ID are a separate installation from the new debug variant; their local data is not migrated automatically.

Build a universal release APK from the application directory:

```powershell
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.
