# sportsman

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/orient-mark/sportsman/total)

English | [Русский](README.ru.md)

An app for athletes and other event participants who use the [OrientMark](https://github.com/orient-mark) checkpoint and timing system.

## Installation

### Android

OrientMark Sportsman for Android is installed from an APK file.

1. Connect to the internet and open the [latest release](https://github.com/orient-mark/sportsman/releases/latest) on your phone.
2. Expand **Assets** below the release description and download the application file ending in **`.apk`**.
3. Open the downloaded file from the download notification or the **Downloads** folder in your file manager.
4. If Android asks for permission to install from this source, tap **Settings** and enable **Allow from this source** for the browser or file manager you used to open the APK.
5. Return to the installer, tap **Install**, and then **Open** when installation finishes.
6. Enable the scanner in the app and allow camera access **while using the app**.

After installation, QR scanning, saved splits, and result transfer work without an internet connection. Participant details and marks are saved on the phone and restored after closing the app.

To update, download the APK for the new release using the same link and install it over the current official version. There is no need to uninstall the app first: a normal update preserves participant details and marks. Android updates are installed manually.

Settings names may vary by device. For help with installations from other sources, see [Google's instructions](https://support.google.com/pixelphone/answer/7391672?hl=en).

### iOS (iPhone)

OrientMark Sportsman is installed from Safari as a web app (PWA).

1. Connect to the internet and open [OrientMark Sportsman](https://orient-mark.github.io/sportsman/) in **Safari**. If the link opens inside a messenger, open it in Safari.
2. Tap **Share** (the square with an upward arrow), then **Add to Home Screen**. You may need to scroll down the action list.
3. Keep the name OrientMark and tap **Add**. If an **Open as Web App** option appears, leave it enabled.
4. Launch OrientMark using the new icon on the Home Screen while still online.
5. Wait for “Приложение готово к работе без интернета” or “Автономная версия доступна” (the offline-ready message).
6. Open the scanner and allow camera access.

After this preparation, QR scanning, saved splits, and result transfer work without an internet connection. Before a competition, check that the app opens from its Home Screen icon in airplane mode.

Updates download automatically while the app is open and online. To apply an update, close the scanner and return to the app's main screen. Saved participant details and marks are retained; reinstalling the app is not required.

For help with the Safari menu, see [Apple's Home Screen instructions](https://support.apple.com/guide/iphone/bookmark-a-website-iph42ab2f3a7/ios).

## User manual

**NOTE:** Before using the app, make sure it has permission to access the camera. This permission is required to scan the system's QR codes.

Once camera access is granted, QR scanning becomes available in the app.

**To complete the course:**

1. Enable the scanner in the app's main menu.
2. Scan the QR codes at each checkpoint. A sound and an animated green checkmark confirm the scan. To illuminate a QR code, tap the lightning bolt button 🗲 in scanning mode if it is available. On iOS, flashlight availability depends on browser and camera support.

**To view your split:**

1. Tap "Показать сплит" on the main screen.
2. On the screen that opens, you can switch to the tab for transferring your split to the event organizer.

**To register in the checkpoint system:**

1. Open settings from the main screen using the gear button ⛭ at the top of the screen.
2. Tap "Ввести данные пользователя" and scan the registration code provided by the organizer.

### Frequently asked questions

**Can I turn off the scanner while completing the course?**

Yes! You can turn off the scanner while it is running. Minimizing or closing the app also turns it off. On long legs, turning off your smartphone can help conserve battery power.

**Can I close the app while completing the course?**

Yes! You can close the app and even turn off your smartphone. Marks are saved immediately to the device's persistent storage, and your split is restored when you restart the app.

On iOS, use the installed Home Screen app. Transfer your result to the organizer before deleting the app or clearing its website data: these actions can remove saved records.

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
