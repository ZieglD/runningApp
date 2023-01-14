import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

  //user collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  //subcollection reference
  // final CollectionReference activityCollection = FirebaseFirestore.instance
  //     .collection('activities')
  //     .doc(uid)
  //     .collection('userActivities');

  // Future updateUserData(String activityName, String activityDuration, double activityDistance, String activityPace) async {
  // Future updateUserData(double activityDistance) async {
  //   return await userCollection.doc(uid).collection('activities').add({
  //     // 'activityName': activityName,
  //     // 'activityDuration': activityDuration,
  //     'activityDistance': activityDistance,
  //     // 'activityPace': activityPace,
  //   });
  // }

  // Future updateUserData(String username) async {
  //   return await userCollection.doc(uid).set({
  //     'username': username,
  //     'userID': uid,
  //   });
  // }

  Future updateUserData(double activityDistance) async {
    return await userCollection.doc(uid).set({
      'activityDistance': activityDistance,
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

  // Future<void> getData() async {
  //   await FirebaseFirestore.instance
  //       .collectionGroup('userActivities')
  //       // .where('userID', isEqualTo: '4JMGmNNuRFeORxsXOG2Anlm9XWN2')
  //       //.where('activityDistance', isEqualTo: 0)
  //       .get()
  //       .then((QuerySnapshot snapshot) {
  //     final docs = snapshot.docs;
  //     for (var data in docs) {
  //       print(data.data());
  //     }
  //   });
  // }
}
