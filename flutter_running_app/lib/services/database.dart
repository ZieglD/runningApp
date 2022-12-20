import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String activityName, String activityDuration, double activityDistance, String activityPace) async {
    // return await userCollection.doc(uid).set({
    //   'activityName': activityName,
    //   'activityDuration': activityDuration,
    //   'activityDistance': activityDistance,
    //   'activityPace': activityPace,
    // });

    return await userCollection.doc(uid).collection('activities').add({
      'activityName': activityName,
      'activityDuration': activityDuration,
      'activityDistance': activityDistance,
      'activityPace': activityPace,
    });
  }

}