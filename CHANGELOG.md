# Changelog

All notable changes to the Gym Bro Tracker project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] - 2025-03-13

### Added

#### Android Project Configuration
- **`android/settings.gradle`** — Gradle settings with `pluginManagement` and declarative `plugins` block
- **`android/gradle.properties`** — JVM args, AndroidX, and Jetifier configuration
- **`android/gradle/wrapper/gradle-wrapper.properties`** — Gradle wrapper configuration (Gradle 8.11.1)
- **`android/gradlew.bat`** — Windows Gradle wrapper script
- **`android/local.properties.example`** — Template for local SDK paths
- **`android/app/local.properties`** — Local Flutter and Android SDK paths (user-configured)

#### Android App Structure
- **`android/app/src/main/kotlin/com/example/gym_bro_tracker/MainActivity.kt`** — Flutter entry activity
- **`android/app/src/main/res/values/colors.xml`** — App color definitions
- **`android/app/src/main/res/values/styles.xml`** — Launch and normal themes
- **`android/app/src/main/res/drawable/launch_background.xml`** — Launch screen background
- **`android/app/src/main/res/drawable/ic_notification.xml`** — Notification icon
- **`android/app/src/main/res/drawable/ic_launcher_background.xml`** — Launcher icon background
- **`android/app/src/main/res/drawable/ic_launcher_foreground.xml`** — Launcher icon foreground
- **`android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`** — Adaptive launcher icon
- **`android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`** — Adaptive round launcher icon
- **`android/app/google-services.json`** — Firebase configuration (placeholder; replace with your own for production)

#### Assets
- **`assets/images/`** — Image assets directory
- **`assets/icons/`** — Icon assets directory

#### Documentation
- **`ANDROID_STUDIO_SETUP_MANUAL.md`** — Complete guide for running the app in Android Studio
- **`CHANGELOG.md`** — This file

#### Dependencies
- **`flutter_local_notifications: ^17.2.3`** — Local notification support for workout, hydration, and protein reminders

#### Model Methods
- **`WaterIntake.copyWith()`** — Added to `lib/models/nutrition_model.dart` for Firestore document creation
- **`ProgressPhoto.copyWith()`** — Added to `lib/models/progress_model.dart` for Firestore document creation

---

### Changed

#### Gradle & Build System
- **Flutter Gradle plugin** — Migrated from imperative `apply` script to declarative `plugins` block (required for Flutter 3.41+)
- **Android Gradle Plugin** — Upgraded from 7.3.0 → 8.2.0 → 8.6.0 → 8.9.1
- **Gradle** — Upgraded from 7.5 → 8.7 → 8.11.1
- **Kotlin** — Upgraded from 1.7.10 → 1.9.22 → 2.1.0
- **Java/Kotlin target** — Upgraded from 1.8 to 17
- **Core library desugaring** — Enabled for `flutter_local_notifications` compatibility
- **`android/build.gradle`** — Removed `buildscript` block (plugin versions moved to `settings.gradle`)

#### `lib/main.dart`
- Fixed `FirebaseMessaging.onBackgroundMessage` call — Added missing parentheses: `FirebaseMessaging.onBackgroundMessage(FirebaseMessagingBackgroundHandler)`

#### `lib/core/theme/app_theme.dart`
- **`CardTheme`** → **`CardThemeData`** — Corrected type for Flutter compatibility

#### `lib/core/services/firestore_service.dart`
- **Model imports** — Changed from relative `../models/` to package imports `package:gym_bro_tracker/models/`
- **Firestore `doc.data()`** — Added explicit `as Map<String, dynamic>` casts for type safety
- **`getTodayNutritionStream`** — Added `Map<String, dynamic>` cast for `snapshot.docs.first.data()`

#### `lib/core/services/notification_service.dart`
- **`Importance.default`** → **`Importance.defaultImportance`** — Avoids Dart 3 `default` keyword conflict
- **`Priority.default`** → **`Priority.defaultPriority`** — Avoids Dart 3 `default` keyword conflict

#### `lib/features/profile/providers/profile_provider.dart`
- **`updateProfileImage()`** — Added `BuildContext context` as first parameter
- **`updateUserProfile()`** — Added `BuildContext context` as first parameter

#### `lib/features/profile/screens/edit_profile_screen.dart`
- **`updateUserProfile()` call** — Now passes `context` as first argument

#### `lib/features/workout/screens/workout_screen.dart`
- **`Icons.rest_time`** → **`Icons.timer`** — `rest_time` is not a valid Material icon

#### `lib/features/auth/onboarding/onboarding_screen.dart`
- **Import** — Added `../../home/screens/home_screen.dart` for `HomeScreen`
- **`MaterialPageRoute` builder** — Removed `const` from `HomeScreen()` (non-const expression)

#### `lib/features/auth/onboarding/fitness_goal_screen.dart`
- **BMI Text widget** — Removed `const` from `Text` containing interpolated `userModel.bmi` (non-const expression)

#### `lib/features/profile/widgets/settings_section.dart`
- **Import** — Added `../screens/edit_profile_screen.dart` for `EditProfileScreen`
- **`MaterialPageRoute` builder** — Removed `const` from `EditProfileScreen()` (non-const expression)

#### `lib/features/progress/providers/progress_provider.dart`
- **`_loadProgressEntries()`** — `getUserProgress()` returns `Stream`, now uses `.first` to get initial value: `await _firestoreService.getUserProgress(userId).first`

#### `pubspec.yaml`
- **Fonts** — Removed Inter font declarations (font files were missing; theme uses default font)
- **Assets** — Retained `assets/images/` and `assets/icons/` declarations

---

### Fixed

- **Gradle build** — Resolved "You are applying Flutter's main Gradle plugin imperatively" error via declarative plugins migration
- **Gradle build** — Resolved "Unresolved reference: filePermissions" in `FlutterPlugin.kt` by upgrading Gradle to 8.7+
- **Gradle build** — Resolved AAR metadata conflicts (AGP 8.9.1, core library desugaring) for `flutter_local_notifications` and AndroidX dependencies
- **Firebase** — Placed `google-services.json` in `android/app/` (required by Google Services plugin)
- **Type safety** — Firestore `doc.data()` returns `Object?`; added casts for `fromMap()` calls
- **Provider context** — `ProfileProvider` no longer references undefined `context`; methods now receive `BuildContext` from callers
- **Stream vs Future** — `ProgressProvider._loadProgressEntries` correctly handles `Stream<List<ProgressEntry>>` from `getUserProgress()`

---

### Technical Details

| Component        | Before    | After      |
|-----------------|-----------|------------|
| Android Gradle Plugin | 7.3.0 | 8.9.1      |
| Gradle          | 7.5       | 8.11.1     |
| Kotlin          | 1.7.10    | 2.1.0      |
| Java target     | 1.8       | 17         |
| Flutter Gradle  | Imperative apply | Declarative plugins |

---

### Notes

- **Firebase**: The included `google-services.json` uses placeholder values. Replace with your own from [Firebase Console](https://console.firebase.google.com/) for authentication, Firestore, Storage, and Cloud Messaging.
- **Flutter SDK**: Project tested with Flutter 3.41.4.
- **Android Studio**: See `ANDROID_STUDIO_SETUP_MANUAL.md` for setup and run instructions.
