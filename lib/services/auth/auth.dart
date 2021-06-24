import 'package:stockup/models/appUser.dart';

abstract class AuthService {
  // auth change AppUser stream
  Stream<AppUser> get user;

  // sign in using email and password
  Future signInWithEmailPassword(String email, String password);

  // register with email and password
  Future registerWithEmailPassword(String email, String password);

  // sign in with google
  Future signInWithGoogle();

  // sign out
  Future signOut();
}
