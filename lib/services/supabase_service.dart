// ============================================================
//  WHAT GOES HERE
//  Supabase client wrapper — use when storing media in
//  Supabase Storage or when using Realtime subscriptions
//  alongside Firestore. Call init() before runApp if you
//  include Supabase.
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseClient get client => Supabase.instance.client;

  Future<void> init({required String url, required String anonKey}) =>
      Supabase.initialize(url: url, anonKey: anonKey);
}
