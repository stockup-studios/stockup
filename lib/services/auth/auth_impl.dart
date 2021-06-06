import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockup/services/auth/auth.dart';
import 'package:stockup/models/appUser.dart';
import 'package:stockup/services/database/database_impl.dart';

class AuthImplementation implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create User object based on firebase
  AppUser _appUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // auth change AppUser stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_appUser);
  }

  // sign in using email and password
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      return _appUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // register with email and password
  Future registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // Create userDocument in database
      DatabaseServiceImpl _db = DatabaseServiceImpl(uid: user.uid);
      Map<String, dynamic> credentials = {
        'uid': user.uid,
        'email': email,
      };
      _db.addCredentials(credentials);
      await _db.initialize();

      return _appUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
