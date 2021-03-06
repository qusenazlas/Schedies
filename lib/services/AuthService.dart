import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_app/model/User.dart';
import 'package:schedule_app/services/CloudDataService.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudDataService _firestore = CloudDataService();
  //create usee object based on FirebaseUser
  User _getUserFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

// change screen by user status
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_getUserFromFirebaseUser);
  }

  //create user with email and password
  Future signUpWithEmailAndPassword(String email, String password,
      {String name,
      String phoneNumber,
      String userStatus,
      String studentID,
      String imageProfile}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _firestore.addUserData(
          user.uid, email, name, phoneNumber, userStatus,
          studentID: studentID, imageProfile: imageProfile);
      return _getUserFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //sign in with email and password;
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _getUserFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
