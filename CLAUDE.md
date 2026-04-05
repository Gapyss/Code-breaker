# CLAUDE.md — Code Breaker

This file provides guidance for AI assistants working in this repository.

## Project Overview

**Code Breaker** (bundle ID `com.gapys.codebreaker`, display name "Gapyspeak") is a Flutter-based English-learning game where players decode words encrypted with a Caesar cipher. The app is fully offline — no backend, no database — and targets Android and iOS.

## Tech Stack

| Concern | Choice |
|---|---|
| Language / Framework | Dart + Flutter 3.29.0 (pinned via FVM) |
| State management | BLoC (`flutter_bloc ^9.1.1`, `bloc ^9.0.0`) |
| Dependency injection | GetIt service locator (`get_it ^8.0.3`) |
| Icons | `cupertino_icons ^1.0.6` |
| Linting | `flutter_lints ^3.0.0` |
| Testing | `flutter_test` |

## Repository Layout

```
lib/
├── main.dart                          # App entry point
├── service_locator.dart               # GetIt DI setup
├── core/
│   ├── app_theme.dart                 # Light + dark ThemeData
│   ├── cipher_challenge.dart          # CipherChallenge model
│   └── cipher_generator.dart          # Caesar cipher + word loading
└── presentation/
    ├── home/
    │   └── home_page.dart             # Difficulty selection screen
    ├── code_breaker/
    │   ├── code_breaker_page.dart     # Main game UI
    │   └── code_breaker_view_model.dart  # ViewModel (bridges UI ↔ BLoC)
    └── widget/
        └── alphabet_buttom_sheet.dart # Alphabet comparison bottom sheet

test/
└── widget_test.dart                   # Minimal smoke tests

asset/
└── wording.txt                        # Word list for challenges (runtime asset)

android/                               # Android platform code + signing config
ios/                                   # iOS platform code
key_store/
└── keystore.jks                       # Android release signing key
gen.dart                               # One-off utility: converts word.txt → wording.txt
word.txt                               # Source word list (before conversion)
```

## Architecture

The project follows **Clean Architecture** with a **BLoC** state management layer.

### Layers

```
Presentation (UI widgets)
    ↕  streams / events
ViewModel  (CodeBreakerViewModel)
    ↕  BLoC events / state
BLoC  (CipherBloc)
    ↕  method calls
Core  (CipherGenerator, CipherChallenge)
    ↕  asset loading
wording.txt
```

### Dependency Injection (`service_locator.dart`)

- `CipherGenerator` — **lazy singleton** (loads words once; cached in memory)
- `CipherBloc` — **lazy singleton** (shared game state machine)
- `CodeBreakerViewModel` — **factory** (new instance per screen)

Register new services here; never instantiate them directly in widgets.

### State Management

`CipherBloc` extends `Bloc<CodeBreakerEvents, CipherChallenge?>`.

- **Event** `GetChallenge(DifficultyMode mode)` — request a new puzzle
- **State** `CipherChallenge?` — current puzzle (`null` before first challenge)

The `CodeBreakerViewModel` wraps the bloc and exposes `StreamController`-backed streams to the UI.

## Core Game Logic

### Caesar Cipher (`lib/core/cipher_generator.dart`)

```dart
String caesarEncrypt(String input, int shift)
```

- Converts input to uppercase.
- Shifts ASCII value of each letter by `shift` (wraps within A–Z).
- Non-alphabetic characters pass through unchanged.
- Shift is derived from `DateTime.now().millisecondsSinceEcond % 25 + 1` (range 1–25).

### Challenge Generation

1. Load `asset/wording.txt` via `rootBundle.loadString()` (cached after first load).
2. Categorize words by length: easy ≤ 3 chars, medium 4–5 chars, hard ≥ 6 chars.
3. Pick a random **example** word and a random **puzzle** word from the selected difficulty bucket.
4. Encrypt both with the same random shift.
5. Reveal one random character position as a hint.
6. Return a `CipherChallenge` containing: `example`, `exampleEncrypted`, `puzzle`, `puzzleEncrypted`, `hint`, `shift`.

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Classes / Widgets | PascalCase | `CipherGenerator`, `CodeBreakerPage` |
| Variables / Methods | camelCase | `generateChallenge`, `shiftValue` |
| Private members | leading underscore | `_controller`, `_puzzleEncrypted` |
| Event classes | suffix `Events` | `CodeBreakerEvents`, `GetChallenge` |
| Screen widgets | suffix `Page` | `HomePage`, `CodeBreakerPage` |
| ViewModel classes | suffix `ViewModel` | `CodeBreakerViewModel` |

## Common Commands

```bash
# Get dependencies
flutter pub get

# Run on a connected device/emulator (debug)
flutter run

# Analyze code (linting)
flutter analyze

# Run tests
flutter test

# Build signed release APK
flutter build apk --release

# Build Android App Bundle (Play Store)
flutter build appbundle --release

# Build iOS release
flutter build ios --release
```

> **Note:** Release builds require `android/keystore.properties` to be present with the keystore credentials. This file is not committed to the repository.

## Flutter Version

The project pins Flutter **3.29.0** via FVM (`.fvmrc`). Use `fvm use` or `fvm flutter` instead of the system `flutter` command if FVM is installed locally.

## Adding a New Screen

1. Create `lib/presentation/<feature>/<feature>_page.dart` (StatelessWidget or StatefulWidget).
2. If the screen needs game state, create a companion `<feature>_view_model.dart`.
3. Register any new services in `lib/service_locator.dart`.
4. Wire navigation from the appropriate existing page.

## Adding a New Cipher Type

1. Implement the encryption/decryption logic in `lib/core/cipher_generator.dart` (or a new file in `lib/core/`).
2. Extend `CipherChallenge` if new fields are required.
3. Add a new `CodeBreakerEvents` subclass and handle it in `CipherBloc`.

## Testing

Tests live in `test/`. The current coverage is minimal (Flutter template smoke test). When writing new tests:

- Use `flutter_test` widget testing for UI behavior.
- Test cipher logic (`caesarEncrypt`, `generateRandomChallenge`) with plain Dart unit tests — no widget setup needed.
- Mock `CipherGenerator` via GetIt overrides when testing the BLoC or ViewModel in isolation.

## Key Files at a Glance

| File | Purpose |
|---|---|
| `lib/main.dart` | Bootstrap: init DI, set theme, run app |
| `lib/service_locator.dart` | GetIt registrations |
| `lib/core/cipher_generator.dart` | All cipher and word-loading logic |
| `lib/core/cipher_challenge.dart` | `CipherChallenge` data model |
| `lib/core/app_theme.dart` | Light / dark `ThemeData` |
| `lib/presentation/home/home_page.dart` | Difficulty selection UI |
| `lib/presentation/code_breaker/code_breaker_page.dart` | Main game UI |
| `lib/presentation/code_breaker/code_breaker_view_model.dart` | ViewModel + BLoC event dispatch |
| `asset/wording.txt` | Bundled word list (loaded at runtime) |
| `pubspec.yaml` | Dependencies and asset declarations |
| `analysis_options.yaml` | Linting rules |
| `.fvmrc` | Pinned Flutter version |

## Known Limitations

- No persistent storage — scores and progress reset on restart.
- Word selection is fully random; the same word can repeat within a session.
- Hint always reveals exactly one letter regardless of difficulty.
- `AlphabetBottomSheet` widget exists but is not yet fully wired into the game flow.
- Test coverage is minimal.
