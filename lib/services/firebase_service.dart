// ============================================================
//  WHAT GOES HERE
//  Thin singleton that holds the initialised Firebase SDK
//  instances other sources need. Registered with Get.put()
//  in InitialBindings before any route loads.
//  Keep it thin — no business logic here.
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth      auth      = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage   storage   = FirebaseStorage.instance;

  bool get isSignedIn => auth.currentUser != null;
}
