import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

  //user collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData() async {
    return await userCollection.doc(uid).set({
      // 'activityDistance': activityDistance,
    });
  }

  Future updateActivities(
    String userID,
    double activityDistance,
  ) async {
    return await FirebaseFirestore.instance
        .collection('activities')
        .doc(uid)
        .collection('userActivities')
        .add({
      'userID': userID,
      'activityDistance': activityDistance,
      // 'activityCoords': activityCoords,
    });
  }

  Future<void> getActivityData() async {
    return await FirebaseFirestore.instance
        .collection('activities')
        .doc(uid)
        .collection('userActivities')
        .where('userID', isEqualTo: uid)
        .get()
        .then((QuerySnapshot snapshot) {
      final docs = snapshot.docs;
      for (var data in docs) {
        print(data.get('activityDistance'));
      }
    });
  }

  // Hier noch Baustelle
  // activity list from snapshot
  // List<ActivityModel> _activityListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.docs.map((doc) {
  //     return ActivityModel(
  //         activityDistance: doc.get('activityDistance') ?? " ");
  //   }).toList();
  // }

  // Get activity stream
  // Stream<List<ActivityModel>> get users {
  //   return userCollection.snapshots().map(_activityListFromSnapshot);
  // }

  // Stream<List<ActivityModel>> get userActivities {
  //   return FirebaseFirestore.instance
  //       .collection('activities')
  //       .doc(uid)
  //       .collection('userActivities')
  //       .where('userID', isEqualTo: uid)
  //       .snapshots()
  //       .map(_activityListFromSnapshot);
  // }
}
