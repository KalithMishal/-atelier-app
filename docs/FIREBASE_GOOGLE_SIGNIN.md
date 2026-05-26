# Google sign-in (Firebase)

If **Continue with Google** fails with *“The given sign-in provider is disabled…”* or similar, fix it in the Google Cloud / Firebase consoles — the app cannot enable providers for you.

## 1. Enable Google in Firebase

1. Open [Firebase Console](https://console.firebase.google.com/) → your project (`fashion-store-app-2ac1f` in the bundled `firebase_options.dart`).
2. **Build** → **Authentication** → **Sign-in method**.
3. Click **Google** → turn **Enable** on → choose a support email → **Save**.

## 2. Web: Authorized JavaScript origins

When running with `flutter run -d chrome`, the app is served at something like `http://localhost:59750`.

1. [Google Cloud Console](https://console.cloud.google.com/) → select the **same** project as Firebase.
2. **APIs & Services** → **Credentials**.
3. Open the **Web client** (OAuth 2.0 Client IDs — type *Web application*). Firebase often creates this as “Web client (auto created by Google Service)”.
4. Under **Authorized JavaScript origins**, add:
   - `http://localhost` (some setups need the portless form), and/or  
   - `http://localhost:PORT` for each port you use (e.g. `http://localhost:59750`).
5. Add your **production** site URL(s) when you deploy (e.g. `https://yourdomain.com`).

Save, wait a minute, then hard-refresh the app and try again.

## 3. Web: Full-page redirect

On web the app uses **sign-in with redirect** only (no popup). After you sign in with Google, Firebase returns you to the app URL; `getRedirectResult()` runs on startup (see `main.dart` / splash / login) so the session is attached before you continue.

If you still see *provider is disabled*, open the in-app **Enable Google in Firebase** dialog from the login screen (it links straight to your project’s Authentication providers page).

## 4. Android

Add your app’s **SHA-1** (and SHA-256) in Firebase → Project settings → Your Android app → **Add fingerprint**, then download an updated `google-services.json` if needed.

## 5. Windows desktop

Google Sign-In on Windows needs a **Desktop** OAuth client ID at run time:

```bash
flutter run -d windows --dart-define=GOOGLE_DESKTOP_CLIENT_ID=YOUR_CLIENT_ID.apps.googleusercontent.com
```

Create that client in Google Cloud Console → Credentials → **OAuth client ID** → Application type **Desktop app**.
