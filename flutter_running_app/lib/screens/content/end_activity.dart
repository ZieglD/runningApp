import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/navigation/navigation.dart';
import 'package:flutter_running_app/services/database.dart';
import 'package:flutter_running_app/shared/data.dart';
import 'package:flutter_running_app/shared/map_widget_end.dart';

import '../../shared/constants.dart';

class EndActivity extends StatefulWidget {
  const EndActivity({super.key});

  @override
  State<EndActivity> createState() => _EndActivityState();
}

class _EndActivityState extends State<EndActivity> {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context);
    User? user = FirebaseAuth.instance.currentUser;

    Widget finishButton = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: success,
              //minimumSize: Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          onPressed: () async {
            await DatabaseService(uid: user?.uid)
                .updateActivities(user!.uid, savedDistance);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Navigation()));
          },
          icon: const Icon(
            Icons.flag,
            color: secondary,
            size: 35,
          ),
          label: const Text(
            'Finish Run',
            style: TextStyle(color: secondary, fontSize: 25),
          ),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          leading: const Icon(
            Icons.directions_run_rounded,
            color: success,
          ),
          title: const Text('Running App'),
          centerTitle: true,
          foregroundColor: light,
          backgroundColor: secondary,
          elevation: 0.0,
        ),
        // body: const Center(child: Text('End', style: TextStyle(fontSize: 60))),
        body: Stack(
          children: [
            const MapWidgetEnd(),
            Stack(
              children: [
                //mapPreview,

                //distanceAndPaceSection,
                //finishAndPauseButtonSection,
                finishButton,
                //startButtonSection,
                //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
              ],
            ),
          ],
        ));
  }
}
