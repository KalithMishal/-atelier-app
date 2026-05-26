# Firebase Android setup (manual — required once)

No tool can create your Firebase project or download `google-services.json` for you: that uses **your Google account** in the [Firebase Console](https://console.firebase.google.com/). Follow the steps below once; after that, the app is tied to your project.

## Your Android package name (must match exactly)

In this project:

- **Application ID / package name:** `com.atelier.app`

When Firebase asks for the **Android package name**, enter exactly:

`com.atelier.app`

(File: `android/app/build.gradle.kts` → `applicationId`.)

---

## Step 1 — Create project and register the Android app

1. Open [Firebase Console](https://console.firebase.google.com/) and sign in with your Google account.
2. Click **Add project** (or use an existing project) → follow the wizard → **Create project**.
3. In the project overview, click the **Android** icon (or **Add app** → **Android**).
4. Fill in:
   - **Android package name:** `com.atelier.app`
   - **App nickname (optional):** e.g. `ATELIER`
   - **Debug signing certificate SHA-1:** optional for Email/Password; add later if you use Google Sign-In.
5. Click **Register app**.
6. Click **Download google-services.json**.
7. **Important:** Put the file here (exact path):

   ```
   android/app/google-services.json
   ```

   So the full path in this repo is:

   `atelier/android/app/google-services.json`

8. Click **Next** through the remaining wizard steps (Gradle is already configured in this project).

---

## Step 2 — Turn on Firebase products

In Firebase Console for the same project:

### Authentication

1. Go to **Build** → **Authentication** → **Get started**.
2. Open the **Sign-in method** tab.
3. Enable **Email/Password** (first provider in the list) → **Save**.

### Cloud Firestore

1. Go to **Build** → **Firestore Database** → **Create database**.
2. Choose **Start in production mode** (you will add rules next) or **test mode** only for a short local test — for coursework, prefer production + rules below.
3. Pick a **location** close to you → **Enable**.

### Cloud Storage (for product images)

1. Go to **Build** → **Storage** → **Get started** → accept defaults → **Done**.

---

## Step 3 — Security rules (recommended)

This repo includes:

- `firestore.rules`
- `storage.rules`

**Option A — Firebase Console (no CLI)**

1. **Firestore** → **Rules** → paste contents of `firestore.rules` → **Publish**.
2. **Storage** → **Rules** → paste contents of `storage.rules` → **Publish**.

**Option B — Firebase CLI**

```bash
npm install -g firebase-tools
firebase login
firebase init   # select Firestore + Storage, link to this project
firebase deploy --only firestore:rules,storage:rules
```

---

## Step 4 — Upload images and seed `products`

### 4a) Upload images to Storage

1. **Storage** → **Files** → create folder `products` (optional but tidy).
2. Upload your images (e.g. `dress1.jpg`).
3. Click a file → copy **download URL** (or get token URL). You will paste these into Firestore as `imageUrls`.

### 4b) Create Firestore `products` collection

1. **Firestore Database** → **Start collection** → Collection ID: `products`.
2. Add a **document** (Auto-ID is fine). Use fields your app expects:

| Field          | Type    | Example |
|----------------|---------|---------|
| `name`         | string  | `Silk Evening Gown` |
| `brand`        | string  | `ATELIER` |
| `categoryId`   | string  | `women` (use your own ids consistently) |
| `price`        | number  | `1250` |
| `currency`     | string  | `USD` |
| `imageUrls`    | array   | add one **string** element = Storage download URL |
| `description`  | string  | Short description |
| `isFeatured`   | boolean | `true` for home “featured” grid |

3. Add several products; set `isFeatured` to `true` on at least a few so the home screen shows them.

**Shortcut:** Copy field values from `tools/products_seed.json` in this repo (replace `imageUrls` with real Storage HTTPS URLs before saving each document).

**Optional:** Collection `categories` with docs like `women` → field `name`: `Women` (for future category UI).

### Deploy rules and indexes

```bash
firebase deploy --only firestore:rules,firestore:indexes,storage:rules
```

If Firestore asks for a composite index on `orders` (`userId` + `createdAt`), deploy `firestore.indexes.json` or use the link in the error message.

---

## Step 5 — Build and run on Android

From the project root:

```bash
flutter pub get
flutter run
```

Or release APK:

```bash
flutter build apk --release
```

Output APK path (typical):

`build/app/outputs/flutter-apk/app-release.apk`

---

## Checklist (copy for your report)

- [ ] `android/app/google-services.json` present  
- [ ] Authentication → Email/Password **enabled**  
- [ ] Authentication → **Google** enabled (recommended for “Continue with Google”)  
- [ ] Authentication → **Apple** enabled (iOS/macOS only; requires Apple Developer setup)  
- [ ] Firestore **created** and rules **published**  
- [ ] Storage **enabled** and rules **published**  
- [ ] `products` collection **seeded** with `imageUrls`  
- [ ] App runs: register → login → see products → cart → checkout  

---

## Google & Apple sign-in (required for social buttons)

The app calls **Firebase Auth** with `google_sign_in` and `sign_in_with_apple`. In Firebase Console → **Authentication** → **Sign-in method**:

1. **Google** — turn on, set support email, **Save**.  
   - **Android:** add your app’s **SHA-1** and **SHA-256** (debug and release keystores) under Project settings → Your apps → Android. Without SHA keys, Google returns no ID token.  
   - **iOS:** download `GoogleService-Info.plist`, add **REVERSED_CLIENT_ID** as a URL scheme in Xcode (Google’s Flutter/Firebase docs).  
   - **Web:** add your dev/prod origins under the Google provider / OAuth client.

2. **Apple** — turn on, **Save**. Only **iPhone, iPad, and Mac** are supported in-app; on Android/Windows use Google or email. In Apple Developer: enable **Sign in with Apple** for the App ID, configure Services ID / return URLs as in Firebase’s Apple provider docs, and add the **Sign in with Apple** capability in Xcode.

**Windows desktop:** enable Google Sign-In by creating a **Desktop** OAuth client in [Google Cloud Console](https://console.cloud.google.com/) → APIs & Services → Credentials, then run the app with:

`--dart-define=GOOGLE_DESKTOP_CLIENT_ID=<your-desktop-client-id>.apps.googleusercontent.com`

The app registers `google_sign_in_dartio` at startup when that value is set. Without it, use **email/password** on Windows.

**Linux:** same `GOOGLE_DESKTOP_CLIENT_ID` approach if you add Linux to `firebase_options` and run on Linux.

Apple Sign-In remains **iOS/macOS only** in-app; on Android/Windows use Google or email.

---

## Troubleshooting

- **“Default FirebaseApp is not initialized”** on Android → missing or wrong `google-services.json` path, or package name in Firebase ≠ `com.atelier.app` (see `android/app/build.gradle.kts` → `applicationId`).
- **Permission denied on Firestore** → rules not deployed or user not signed in.
- **Images blank** → `imageUrls` must be full **https** download URLs; Storage rules must allow read for `products/**` (see `storage.rules` in this repo).
