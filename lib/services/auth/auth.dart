import 'package:stockup/models/app_user.dart';

abstract class AuthService {
  // auth change AppUser stream
  Stream<AppUser> get user;

  // sign in using email and password
  Future signInWithEmailPassword(String email, String password);

  // register with email and password
  Future registerWithEmailPassword(String email, String password);

  // sign in with google
  Future signInWithGoogle();

  // password reset
  dynamic resetPassword(String email);

  // sign out
  Future signOut();
}
