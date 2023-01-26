import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/database.dart';

class ActivitiesList extends StatefulWidget {
  const ActivitiesList({super.key});

  @override
  State<ActivitiesList> createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    DatabaseService(uid: user?.uid).getActivityData();

    // Noch nicht fertig
    // final activities = Provider.of<List<ActivityModel>>(context);
    // print('blub');
    // print(activities);
    // activities.forEach((activity) {
    //   print('list ${activity.activityDistance}');
    // });

    // StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection('activities')
    //       .doc(user?.uid)
    //       .collection('userActivities')
    //       .snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       // ListView.builder(
    //       //   itemCount: snapshot.data?.docs.length,
    //       //   itemBuilder: (context, index) {
    //       //     DocumentSnapshot activityData = snapshot.data!.docs[index];
    //       //     return ListTile(
    //       //       title: Text('Distance $activityData'),
    //       //     );
    //       //   },
    //       // );
    //       List<QueryDocumentSnapshot<Map<String, dynamic>>> activityData =
    //           snapshot.data!.docs;
    //       print('bitte');
    //       print(activityData);
    //     }
    //     return Text('bla');
    //   },
    // );

    return Container();
  }
}
