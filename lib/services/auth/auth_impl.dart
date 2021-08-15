import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockup/models/app_user.dart';
import 'package:stockup/services/auth/auth.dart';
import 'package:stockup/services/database/database_impl.dart';

class AuthImplementation implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser appUser;

  /// create User object based on firebase
  AppUser _appUser(User user) {
    if (user != null) {
      appUser = AppUser(username: user.uid, email: user.email);
      return appUser;
    } else {
      return null;
    }
  }

  /// can get from database
  /// auth change AppUser stream
  @override
  Stream<AppUser> get user {
    return _auth.authStateChanges().map((element) => _appUser(element));
  }

  /// sign in using email and password
  @override
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      // appUser = _appUser(user); //create a database method get user.
      // DatabaseServiceImpl _db = DatabaseServiceImpl(uid: user.uid);

      appUser = _appUser(user);
      return appUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// register with email and password
  @override
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
      await _db.addCredentials(credentials);
      await _db.initialize(); // default data
      appUser = _appUser(user);
      return appUser;
    } catch (e) {
      print(e.toString());
    }
  }

  /// password reset
  @override
  dynamic resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 1;
    } catch (e) {
      return null;
    }
  }

  /// sign out
  @override
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
