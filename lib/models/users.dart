import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  static Future<void> createUser(String uid, String displayName, String email, String registrationNumber) async {
    return await usersCollection.doc(uid).set({
      'displayName': displayName,
      'email': email,
      'rank': 0,
      'blocked':false
    });
  }

  static Future<DocumentSnapshot> getUser(String uid) async {
    return await usersCollection.doc(uid).get();
  }

  static Future<void> updateUserRank(String uid, int rank) async {
    return await usersCollection.doc(uid).update({'rank': rank});
  }

  static Future<void> addRollNumber (String uid, String rollNumber) async {
    return await usersCollection.doc(uid).update({'rollNumber': rollNumber});
  }


  static Future<void> blockUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'blocked': true,
    });



      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'rank': 0,
      });

  }

  static Future<bool> isUserBlocked(String uid) async {
    DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    if (userDoc.exists) {
      return userDoc.get('blocked') ?? false;
    } else {
      return false;
    }
  }

  static Stream<QuerySnapshot<Object?>> getChampions() {
    return usersCollection.orderBy('rank', descending: true).limit(10).snapshots();
  }


  static Future<void> decreaseRank(String userID)async {
    late int currentRank;
    await getUser(userID).then((value){
      currentRank = value['rank'];
    });

    await usersCollection.doc(userID).update({
      "rank" : currentRank - 1
    });
  }
}
