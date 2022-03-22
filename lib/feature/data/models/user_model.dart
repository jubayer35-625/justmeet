
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String name,
    required String email,
    required String phoneNumber,
    required bool isOnline,
    required String uid,
    required String status,
    required String profileUrl,
  }) : super(
    name: name,
    email: email,
    phoneNumber: phoneNumber,
    isOnline: isOnline,
    uid: uid,
    status: status,
    profileUrl: profileUrl,
  );

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot.get(['name']).toString(),
      email: snapshot.get(['email']).toString(),
      phoneNumber: snapshot.get(['phoneNumber']).toString(),
      uid: snapshot.get(['uid']).toString(),
      isOnline: snapshot.get(['isOnline']),
      profileUrl: snapshot.get(['profileUrl']).toString(),
      status: snapshot.get(['status']).toString(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "isOnline": isOnline,
      "profileUrl": profileUrl,
      "status": status,
    };
  }
}