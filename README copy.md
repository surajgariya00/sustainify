# Sustainify Cool
A stylish, offline-first **Sustainable Living & Climate Action** Flutter app.

- 100% **Flutter** (no paid backend).
- **Hive** local storage.
- Built-in **charts** (fl_chart).
- **Dark neo theme** with glassmorphism + gradients.
- **CI/CD** via GitHub Actions (build/test, deploy Web to Pages, Release APK).

## Run
```bash
flutter pub get
flutter run
```

## Build
```bash
flutter build apk --debug
flutter build web --release
```

## CI/CD
See `.github/workflows` for:
- `flutter-ci.yml` — analyze, test, build, upload artifacts on each push/PR.
- `deploy-web.yml` — auto-deploy Flutter Web to GitHub Pages on pushes to `main`.
- `release-apk.yml` — attach APK to release on tags like `v1.0.0`.
