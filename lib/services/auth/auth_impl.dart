import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stockup/models/app_user.dart';
import 'package:stockup/services/auth/auth.dart';
import 'package:stockup/services/database/database_impl.dart';

class AuthImplementation implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser appUser;
  // String appUserUid;
  // String userUid;

  // create User object based on firebase
  AppUser _appUser(User user) {
    return user != null ? AppUser(username: user.uid) : null;
  }

  //can get from database
  // auth change AppUser stream
  // @override
  // Stream<AppUser> get user {
  //   return _auth.authStateChanges().map((element) => _appUser(element, name));
  // }

  // sign in using email and password
  @override
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = userCredential.user;
      // appUser = _appUser(user); //create a database method get user.
      DatabaseServiceImpl _db = DatabaseServiceImpl(uid: user.uid);
      appUser = await _db.getUserbyName(user.uid);
      return appUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  @override
  Future registerWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;

      // Create userDocument in database
      DatabaseServiceImpl _db = DatabaseServiceImpl(uid: user.uid);
      Map<String, dynamic> credentials = {
        'uid': user.uid,
        'email': email,
        'name': name,
      };
      // await _db.addAppUser(appUser);
      await _db.addCredentials(credentials);
      await _db.initialize(); // default data
      appUser = await _db.getUserbyName(name);
      //appUser = _appUser(user, name);
      return appUser;
    } catch (e) {
      print(e.toString());
    }
  }

  // sign in with google (not complete, need fingerprint key)
  @override
  Future signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User user = userCredential.user;

      AdditionalUserInfo additionalUserInfo = userCredential.additionalUserInfo;
      if (additionalUserInfo.isNewUser) {
        DatabaseServiceImpl _db = DatabaseServiceImpl(uid: user.uid);
        Map<String, dynamic> profile = additionalUserInfo.profile;
        Map<String, dynamic> credentials = {
          'uid': user.uid,
          'email': profile['email'],
          'name': profile['name'],
        };

        // AppUser appUser = AppUser(
        //     username: user.uid, name: profile['name'], email: profile['email']);
        // await _db.addAppUser(appUser);
        _db.addCredentials(credentials);
        await _db.initialize();
      }

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
