import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UsersUid {
  UsersUid({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<UsersUid> get onAuthStateChanged;
  Future<UsersUid> currentUser();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  UsersUid _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UsersUid(uid: user.uid);
  }

  @override
  Stream<UsersUid> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UsersUid> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
