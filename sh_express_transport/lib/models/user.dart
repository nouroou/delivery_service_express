import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username, name, phoneNum, role, photoUrl;
  final Map<String, dynamic> documents;
  final bool verified, contractSigned;
  final Timestamp createdAt, timeVerified;
  final List<String> truckPhotos;

  User(
      {required this.documents,
      required this.username,
      required this.name,
      required this.phoneNum,
      required this.role,
      required this.photoUrl,
      required this.verified,
      required this.contractSigned,
      required this.createdAt,
      required this.timeVerified,
      required this.truckPhotos});

  Map toMap(User user) {
    var data = <String, dynamic>{};
    data['username'] = user.username;
    data['name'] = user.name;
    data['phoneNum'] = user.phoneNum;
    data['role'] = user.role;
    data['photoUrl'] = user.photoUrl;
    data['verified'] = user.verified;
    data['contractSigned'] = user.contractSigned;
    data['timeVerified'] = user.timeVerified;
    data['truckPhotos'] = user.truckPhotos;
    data['createdAt'] = user.createdAt;
    data['insurence'] = user.documents;

    return data;
  }

  User.fromMap(Map<dynamic, dynamic> mapData)
      : username = mapData['username'],
        name = mapData['name'],
        phoneNum = mapData['phoneNum'],
        role = mapData['role'],
        photoUrl = mapData['photoUrl'],
        verified = mapData['verified'],
        contractSigned = mapData['contractSigned'],
        createdAt = mapData['createdAt'],
        timeVerified = mapData['timeVerified'],
        truckPhotos = mapData['truckPhotos'],
        documents = mapData['documents'];

  Map<String, dynamic> toData() {
    return {
      'username': username,
      'name': name,
      'phoneNum': phoneNum,
      'role': role,
      'photoUrl': photoUrl,
      'verified': verified,
      'createdAt': createdAt,
      'contractSigned': contractSigned,
      'timeVerified': timeVerified,
      'truckPhotos': truckPhotos,
      'documents': documents,
    };
  }

  factory User.fromData(DocumentSnapshot doc) {
    return User(
      username: doc['username'],
      name: doc['name'],
      phoneNum: doc['phoneNum'],
      role: doc['role'],
      verified: doc['verified'],
      timeVerified: doc['timeVerified'],
      contractSigned: doc['contractSigned'],
      createdAt: doc['createdAt'],
      truckPhotos: doc['truckPhotos'],
      photoUrl: doc['photoUrl'],
      documents: doc['documents'],
    );
  }
}
