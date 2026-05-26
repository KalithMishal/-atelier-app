import 'package:shared_preferences/shared_preferences.dart';

/// Loaded once in [main] before [runApp] so desktop (no Firestore) features
/// like the wishlist can use [atelierSharedPreferences].
late final SharedPreferences atelierSharedPreferences;

Future<void> initAtelierSharedPreferences() async {
  atelierSharedPreferences = await SharedPreferences.getInstance();
}
