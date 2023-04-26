import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  final storageRef = FirebaseStorage.instance.ref();
  final cloudRef = FirebaseFirestore.instance;

  Future checkIfUserIsVerified(String userId) async {
    cloudRef.collection('users').doc(userId).get().then((value) {
      if (value.exists && value.id == userId) {
        var dataSnapshot = value.data();
        if (dataSnapshot!.entries.contains({'verified': 'true'})) {
          print('User is Verified');
        }
      }
    });
  }

  Future checkIfUserHasAllData() async {}
}
