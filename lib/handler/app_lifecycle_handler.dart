import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram/core/constants/app_constants.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateStatus(String status) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .update({'status': status});
  }

  Future<void> setOnline() async {
    await _updateStatus('online');
  }

  Future<void> setOffline() async {
    await _updateStatus('offline');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setOnline();
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        setOffline();
        break;
    }
  }
}
