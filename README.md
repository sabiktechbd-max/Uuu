# PrivateAgent

PrivateAgent is an open-source Android automation agent built with Flutter. It utilizes the DeepSeek API and native Android Accessibility Services to interpret screen layouts and execute multi-step tasks across any installed application via natural language commands.

## Architecture

The system operates on a continuous feedback loop:
1. The user issues a command (via voice, text, or Telegram remote access).
2. The agent captures the current screen hierarchy, calculating the exact spatial coordinates of all interactive elements.
3. The layout data is transmitted to the AI provider alongside the current task context and the result of the previous action.
4. The AI determines the next optimal action (e.g., clicking specific coordinates, inputting text, scrolling).
5. The native Android layer executes the action.
6. The loop repeats until the task is marked as complete.

## Capabilities

- **Screen Reading:** Parses the Android UI tree to map clickable, scrollable, and editable elements.
- **Coordinate-Based Interaction:** Simulates physical screen taps based on coordinate geometry, mitigating issues with missing text labels or inaccessible icons.
- **Remote Access:** Integrates with the Telegram Bot API via background polling, allowing users to issue commands and monitor task execution progress remotely.
- **Voice Control:** Native speech-to-text integration for hands-free operation.

## Installation

Download the latest APK directly from the [Releases Page](https://github.com/orailnoor/private-agent/releases).

Choose `app-universal-release.apk` when it is available. It supports ARM64,
32-bit ARM, and x86_64 devices in one package. If a release only provides split
APKs, most modern Android phones—including Snapdragon devices—must use
`app-arm64-v8a-release.apk`.

PrivateAgent supports Android 8.0 (API 26) and newer. Current release builds are
also checked for Android 15/16's 16 KB native-library alignment requirement.

## Setup Instructions (How to use for FREE)

This app requires an AI brain to operate. You can use it **100% for free** by using OpenRouter's free models.

1. Install the APK on your Android device (API 30+ recommended).
2. Go to [OpenRouter.ai](https://openrouter.ai/) and create a free account.
3. Generate a free API Key.
4. Launch PrivateAgent and go to the **Settings** screen.
5. Tap the **"OpenRouter"** quick-select chip under Base URL.
6. Paste your API Key.
7. Type `openai/gpt-oss-120b:free` (or any other free model) into the Model field.
8. Enable the **"PrivateAgent Screen Control"** service in your Android Accessibility Settings.

### “Restricted setting” when enabling Screen Control

Android may block accessibility access for apps installed from an APK. This is
an operating-system safety restriction:

1. Open **Settings → Apps → PrivateAgent**.
2. Open the three-dot menu in the top-right corner.
3. Tap **Allow restricted settings** and confirm.
4. Return to PrivateAgent and open **Accessibility Settings** again.
5. Enable **PrivateAgent Screen Control**.

PrivateAgent now shows these instructions and provides shortcuts to both App
Info and Accessibility Settings during onboarding.

## Telegram Integration

To enable remote access:
1. Acquire a bot token from BotFather on Telegram.
2. Input the token in the PrivateAgent Settings screen and enable the integration toggle.
3. The application will maintain a background polling connection to the Telegram API to receive commands.

## License

This project is open-source and available for modification.


## Build and test (Android)

This repository is an existing Flutter Android app. Keep the current application ID
`com.orailnoor.privateagent`, namespace, minimum SDK, and signing setup unless you
intentionally plan a migration.

Prerequisites:
- Flutter SDK compatible with the `environment.sdk` constraint in `pubspec.yaml`
- Android Studio / Android SDK and platform tools
- JDK 17
- Android device or emulator

From the repository root:

```bash
flutter doctor
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The universal APK is normally written to
`build/app/outputs/flutter-apk/app-release.apk`.

### GitHub Actions APK

1. Push this repository to GitHub.
2. Open **Actions** and select **Android release artifacts**.
3. Choose **Run workflow** and confirm.
4. Wait for the workflow to finish successfully.
5. Open the completed run and download the `private-agent-android-...` artifact.
6. Unzip the artifact to access the APK files and `SHA256SUMS.txt`.

The workflow runs dependency resolution, static analysis, tests, and release APK builds.
A downloadable artifact exists only if all required workflow steps succeed. The current
Gradle release configuration uses the debug signing key; this is suitable for local
testing, not a production release. Configure a private release keystore through protected
GitHub Secrets before distributing a production build; never commit the keystore or its
passwords.

## Privacy, permissions, and limitations

- Microphone access is used for user-initiated speech recognition. Android speech
  recognition and TTS language availability depends on the installed recognition/TTS
  services and downloaded language packs.
- This repository does **not** currently provide a verified native wake-word engine.
  Push-to-talk must not be described as always-on “Hey PrivateAgent” detection.
- Android restricts changing protected system settings and running microphone services
  in the background. Settings shortcuts, permission prompts, OEM battery restrictions,
  and Android-version rules still apply.
- Accessibility automation requires the user to enable the service in Android Settings.
  It can interact with sensitive on-screen content; enable it only if you understand and
  trust the feature.
- Shizuku commands are now restricted to a small allowlist of Wi-Fi/Bluetooth toggles.
  Arbitrary shell commands, app-data clearing, and force-stop commands are rejected.
- AI provider credentials configured in app preferences are not a production-grade secret
  store. Do not distribute a shared provider key in an APK. For production, route requests
  through an authenticated backend that stores provider credentials server-side.
- AI features require internet access and a valid provider endpoint/key; offline mode
  does not provide cloud-model responses. Provider pricing, quotas, model availability,
  and supported modalities vary.
- Contact, call, SMS, notification, screen-reading, and other capabilities depend on
  Android permissions, service configuration, installed apps, and device policy. Some
  actions may open a system app or confirmation screen instead of completing silently.

## Validation status

The repository update adds automated tests for the Shizuku command allowlist and extends
the GitHub Actions workflow to run `flutter analyze` and `flutter test` before building.
The editing environment used to prepare this source archive did not have the Flutter/Dart
SDK installed, so local compilation and tests could not be executed here. Treat the GitHub
Actions run as the required build verification; do not assume an APK exists until that
workflow passes.
