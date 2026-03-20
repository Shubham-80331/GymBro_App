# Gym Bro Tracker - Android Studio Setup & Run Manual

This guide explains how to run the **Gym Bro Tracker** Flutter application (from the windsurf-project) in Android Studio.

> **Note:** The project has been configured for Android Studio. The following files were added/updated:
> - `android/settings.gradle`, `gradle.properties`, `gradle/wrapper/gradle-wrapper.properties`
> - `android/app/src/main/kotlin/.../MainActivity.kt`
> - `android/app/src/main/res/` (drawables, styles, colors, launcher icons)
> - Fixed syntax in `lib/main.dart` (FirebaseMessaging)

---

## Prerequisites

Before you begin, ensure you have the following installed:

| Requirement | Version | How to Verify |
|-------------|---------|---------------|
| **Flutter SDK** | >= 3.10.0 | Run `flutter doctor` in terminal |
| **Android Studio** | Latest (Hedgehog or newer) | — |
| **Android SDK** | API 21+ | Installed via Android Studio SDK Manager |
| **Java JDK** | 11 or 17 | `java -version` in terminal |
| **Firebase** | — | Google account for Firebase Console |

---

## Step 1: Install Flutter SDK (if not installed)

1. Download Flutter from: https://docs.flutter.dev/get-started/install
2. Extract to a location (e.g., `C:\flutter`)
3. Add Flutter to your PATH:
   - Add `C:\flutter\bin` to your system PATH
4. Run `flutter doctor` to verify installation

---

## Step 2: Configure local.properties

The Android build requires the Flutter SDK path. Create the file:

**Path:** `windsurf-project/android/local.properties`

1. Copy `windsurf-project/android/local.properties.example` to `local.properties`
2. Edit `local.properties` and set:
   - `sdk.dir` = Your Android SDK path (e.g., `C\:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk`)
   - `flutter.sdk` = Your Flutter SDK path (e.g., `C\:\\flutter` or `C\:\\src\\flutter`)

**Example:** (use double backslashes `\\` for Windows paths)
```properties
sdk.dir=C\:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk
flutter.sdk=C\:\\path\\to\\flutter
```

- Find Android SDK: **Android Studio → Settings → Languages & Frameworks → Android SDK**
- Find Flutter: Where you extracted the Flutter SDK

---

## Step 3: Open Project in Android Studio

1. Launch **Android Studio**
2. Click **File → Open**
3. Navigate to: `c:\git\GymBroAndroid\windsurf-project`
4. Select the **windsurf-project** folder and click **OK**
5. Wait for Android Studio to:
   - Index the project
   - Resolve Gradle dependencies
   - Sync Flutter packages

> **Important:** Open the **windsurf-project** folder (the Flutter project root), NOT the `android` subfolder.

---

## Step 4: Install Flutter Plugin (if needed)

1. Go to **File → Settings** (or **Android Studio → Preferences** on Mac)
2. Navigate to **Plugins**
3. Search for **Flutter**
4. Install the **Flutter** plugin (this also installs the Dart plugin)
5. Restart Android Studio

---

## Step 5: Get Dependencies

Open the terminal in Android Studio (**View → Tool Windows → Terminal**) and run:

```bash
cd c:\git\GymBroAndroid\windsurf-project
flutter pub get
```

---

## Step 6: Firebase Setup (Required for full functionality)

The app uses Firebase for authentication, database, and notifications. The included `google-services.json` has placeholder values. For a working app:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use existing)
3. Add an **Android app** with package name: `com.example.gym_bro_tracker`
4. Download the `google-services.json` file
5. Replace `windsurf-project/android/app/google-services.json` with your downloaded file
6. Enable in Firebase Console:
   - **Authentication** (Email/Password, Google)
   - **Cloud Firestore**
   - **Storage**
   - **Cloud Messaging**

---

## Step 7: Run the App

### Option A: Using Flutter (Recommended)

1. In the terminal:
   ```bash
   flutter run
   ```
2. Select your connected Android device or emulator when prompted

### Option B: Using Android Studio UI

1. Ensure an **Android Emulator** is running or a **physical device** is connected via USB (with USB debugging enabled)
2. Select your device from the device dropdown in the toolbar
3. Click the **Run** (green play) button, or press **Shift+F10**

### Option C: Run Configuration

1. Go to **Run → Edit Configurations**
2. Click **+** → **Flutter**
3. Set **Dart entrypoint** to `lib/main.dart`
4. Set **Working directory** to `c:\git\GymBroAndroid\windsurf-project`
5. Click **OK** and run

---

## Step 8: Build APK (Optional)

To create a release APK:

```bash
cd c:\git\GymBroAndroid\windsurf-project
flutter build apk
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## Troubleshooting

### "Flutter SDK not found"
- Ensure `local.properties` exists in `android/` with correct `flutter.sdk` path
- Use double backslashes: `C\:\\flutter`

### "Gradle build failed"
- Run `flutter clean` then `flutter pub get`
- In Android Studio: **File → Invalidate Caches → Invalidate and Restart**

### "google-services.json" errors
- Replace with your own Firebase project's `google-services.json`
- Ensure package name is `com.example.gym_bro_tracker`

### No devices shown
- Start an Android Emulator: **Tools → Device Manager → Create/Start**
- For physical device: Enable **Developer Options** and **USB Debugging**

### Assets or font errors
- The app uses fallbacks for missing assets (e.g., Google logo shows an icon if image is missing)
- Add `assets/icons/google_logo.png` for the Google Sign-In button icon if desired

---

## Project Structure (Relevant for Android)

```
windsurf-project/
├── android/                 # Android-specific files
│   ├── app/
│   │   ├── build.gradle
│   │   ├── src/main/
│   │   │   ├── kotlin/      # MainActivity.kt
│   │   │   ├── res/         # Icons, styles, colors
│   │   │   └── AndroidManifest.xml
│   │   └── google-services.json
│   ├── build.gradle
│   ├── settings.gradle
│   ├── gradle.properties
│   └── local.properties     # YOU CREATE THIS
├── lib/                     # Flutter/Dart source code
├── pubspec.yaml
└── assets/
```

---

## Environment & Dependency Versions

| Package | Version |
|---------|---------|
| Flutter SDK | >= 3.10.0 |
| Dart SDK | >= 3.0.0 |
| provider | ^6.1.1 |
| firebase_core | ^2.24.2 |
| firebase_auth | ^4.15.3 |
| cloud_firestore | ^4.13.6 |
| firebase_storage | ^11.5.6 |
| firebase_messaging | ^14.7.6 |
| fl_chart | ^0.64.0 |
| image_picker | ^1.0.4 |
| google_sign_in | ^6.1.6 |
| Android Gradle Plugin | 7.3.0 |
| Kotlin | 1.7.10 |
| Gradle | 7.5 |

---

## Quick Reference Commands

```bash
# Navigate to project
cd c:\git\GymBroAndroid\windsurf-project

# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Clean build
flutter clean && flutter pub get

# Build APK
flutter build apk

# Check Flutter setup
flutter doctor
```

---

**Built for fitness enthusiasts** | Gym Bro Tracker
