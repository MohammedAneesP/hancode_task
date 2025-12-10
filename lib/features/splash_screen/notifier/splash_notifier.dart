import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final splashProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final user = FirebaseAuth.instance.currentUser;
  return user != null;
});
