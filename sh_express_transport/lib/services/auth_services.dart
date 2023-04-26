import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sh_express_transport/models/user.dart' as user;

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final usersRef = FirebaseFirestore.instance.collection('users');

  Future loginUser(String email, String password) async {
    var result = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (value.user != null) {
        return value.user;
      } else {
        return 'This user does not exist';
      }
    }).catchError((FirebaseAuthException e) {
      return e.message;
    });
    print(result.toString());
    return result;
  }

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = currentUser;
    return currentUser;
  }

  Future<user.User> getUserDetails() async {
    User currentUser = await getCurrentUser();
    DocumentSnapshot doc = await usersRef.doc(currentUser.uid).get();

    return user.User.fromData(doc);
  }
}
