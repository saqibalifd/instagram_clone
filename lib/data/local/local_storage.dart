// ============================================================
//  WHAT GOES HERE
//  SharedPreferences wrapper — single source of truth for
//  lightweight local state:
//    • Theme preference (dark / light)
//    • Onboarding completion flag
//    • Cached user-id for splash routing
//  Keep all SP keys private. Never scatter sp.getString() calls
//  across the app — always go through this class.
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _p;
  LocalStorage(this._p);

  // ── Keys ───────────────────────────────────────────────────
  static const _kTheme      = 'theme_mode';
  static const _kOnboarded  = 'onboarding_complete';
  static const _kUserId     = 'cached_user_id';

  // ── Theme ──────────────────────────────────────────────────
  bool get isDarkMode => _p.getBool(_kTheme) ?? false;
  Future<void> setDarkMode(bool v) => _p.setBool(_kTheme, v);

  // ── Onboarding ─────────────────────────────────────────────
  bool get isOnboarded => _p.getBool(_kOnboarded) ?? false;
  Future<void> markOnboarded() => _p.setBool(_kOnboarded, true);

  // ── Session ────────────────────────────────────────────────
  String? get cachedUserId => _p.getString(_kUserId);
  Future<void> cacheUserId(String id) => _p.setString(_kUserId, id);
  Future<void> clearSession()         => _p.remove(_kUserId);
}
