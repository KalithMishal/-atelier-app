# atelier

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Men’s accessories images

**Men → Accessories** tiles use **bundled** files under `assets/images/men_accessories/` (see `lib/data/men_accessories_catalog_image_urls.dart`). The same NOLIMIT `_next/image?url=…` links you use on the site are documented in that file as comments.

After clone or SKU change, refresh binaries:

```bash
dart run tool/download_men_accessory_assets.dart
```

Commit those six images with the repo for grading. **Firestore:** re-seed products or rely on seeded-id merge (`lib/data/local_catalogue.dart`).

## Phase 2 (Firebase) setup

**Full step-by-step (Android package, Console clicks, seeding, rules):** see [docs/FIREBASE_ANDROID_SETUP.md](docs/FIREBASE_ANDROID_SETUP.md).

### 1) Create Firebase project
- Create a Firebase project in the Firebase Console.
- Add an **Android app** with your app id (see `android/app/build.gradle.kts` -> `applicationId`).

### 2) Configure Android
- Download `google-services.json` from Firebase and place it here:
  - `android/app/google-services.json`
- In Firebase Console enable **Authentication → Email/Password**.

### 3) Firestore + Storage
- Enable **Cloud Firestore** and **Firebase Storage**.
- Deploy the security rules included in this repo:
  - `firestore.rules`
  - `storage.rules`

### 4) Seed Firestore data (required)
Create a `products` collection. Each product document should include at least:
- `name` (string)
- `brand` (string)
- `categoryId` (string)
- `price` (number)
- `currency` (string, e.g. `USD`)
- `imageUrls` (array of strings; download URLs from Firebase Storage)
- `description` (string)
- `isFeatured` (bool)

Optionally create a `categories` collection.

### 5) Run the app
```bash
flutter pub get
flutter run
```
