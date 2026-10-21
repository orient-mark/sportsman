# sportsman

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/orient-mark/sportsman/total)

English | [Русский](README.ru.md)

An app for athletes and other event participants who use the [OrientMark](https://github.com/orient-mark) checkpoint and timing system.

## User manual

The app currently supports Android only.

Download the APK file to your device using this direct [link](https://github.com/orient-mark/sportsman/releases/download/0.8.0/OrientMark-Sportsman-0.8.0.apk). You can also choose a suitable version from the list of [releases](https://github.com/orient-mark/sportsman/releases).

**NOTE:** Before using the app, make sure it has permission to access the camera. This permission is required to scan the system's QR codes.

Once camera access is granted, QR scanning becomes available in the app.

**To complete the course:**

1. Enable the scanner in the app's main menu.
2. Scan the QR codes at each checkpoint. A sound and an animated green checkmark confirm the scan.
3. To illuminate a QR code, tap the lightning bolt button 🗲 in scanning mode.

To view your split, tap "Показать сплит" on the main screen. On the screen that opens, you can switch to the tab for transferring your split to the event organizer.

To register in the checkpoint system:

1. Open settings from the main screen using the gear button ⛭ at the top of the screen.
2. Tap "Ввести данные пользователя" and scan the registration code provided by the organizer.

### Frequently asked questions

**Can I turn off the scanner while completing the course?**

Yes! You can turn off the scanner while it is running. Minimizing or closing the app also turns it off. On long legs, turning off your smartphone can help conserve battery power.

**Can I close the app while completing the course?**

Yes! You can close the app and even turn off your smartphone. Marks are saved immediately to the device's persistent storage, and your split is restored when you restart the app.

**Can I complete the course before registering in the system?**

Yes! You can complete the course before registering and view your split. However, the split does not indicate whether you completed the course correctly. To receive a result, you still need to submit your split to the course organizer.

## Features

- Registers a user via a dedicated QR code.
- Scans QR codes for the start, finish, checkpoints, and clearing stored split data.
- Stores user data and recorded checkpoint marks locally.
- Displays the user's result as a series of QR codes.

## Development

Repository: [orient-mark/sportsman](https://github.com/orient-mark/sportsman).
Development branch: `dev`. License: [GPL-3.0](LICENSE).

The build targets Flutter 3.47.x / Dart 3.13.x. The Android configuration uses Kotlin DSL (`.gradle.kts`): Gradle 9.3.1, Android Gradle Plugin 9.1.0, Kotlin 2.4.0, and Java/Kotlin bytecode targeting version 17.

From the `sportsman` directory, run:

```
flutter pub get
dart run build_runner build
flutter analyze
flutter build apk --debug
flutter run
```

Kotlin incremental compilation is temporarily disabled in `android/gradle.properties` (`kotlin.incremental=false`). This works around a `mobile_scanner` cache error on Windows when the project and the Pub cache are located on different drives. Kotlin recompilation may take longer, but this setting does not disable Dart hot reload. Once the project and the Pub cache are on the same drive, you can remove the setting, run `flutter clean` and `flutter pub get`, and then check the build again.
