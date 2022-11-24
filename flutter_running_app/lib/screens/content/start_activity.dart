import 'package:flutter/material.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';

class StartActivity extends StatefulWidget {
  const StartActivity({super.key});

  @override
  State<StartActivity> createState() => _StartActivityState();
}

class _StartActivityState extends State<StartActivity> {
  final AuthService _auth = AuthService();
  // bool _showAppBar = true;

  @override
  Widget build(BuildContext context) {
    Widget durationSection = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: const <Widget>[
            Text(
              'Duration',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '00:00:00',
              style: TextStyle(
                //fontWeight: FontWeight.normal,
                fontSize: 80,
              ),
            ),
          ],
        ),
      ],
    );

    Widget distanceAndPaceSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: const <Widget>[
            Text(
              'Distance (km)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '0,00',
              style: TextStyle(
                //fontWeight: FontWeight.normal,
                fontSize: 30,
              ),
            ),
          ],
        ),
        Column(
          children: const <Widget>[
            Text(
              'Pace (min/km)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '00:00:00',
              style: TextStyle(
                //fontWeight: FontWeight.normal,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ],
    );

    Widget finishAndPauseButtonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  iconSize: 75,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  onPressed: () {},
                ))
          ],
        ),
        Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: IconButton(
                  iconSize: 75,
                  icon: const Icon(Icons.lock_open_outlined),
                  onPressed: () {},
                ))
          ],
        ),
      ],
    );

    // Widget startButtonSection = IconButton(
    //   iconSize: 150,
    //   icon: const Icon(Icons.play_circle_outline_rounded),
    //   onPressed: () {},
    // );

    Widget startButtonSection = Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: IconButton(
          iconSize: 150,
          icon: const Icon(Icons.play_circle_outline_rounded),
          onPressed: () {},
        ));

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        leading: const Icon(
          Icons.directions_run_rounded,
          color: primary,
        ),
        title: const Text('Running App'),
        centerTitle: true,
        foregroundColor: light,
        backgroundColor: secondary,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            style: TextButton.styleFrom(
              foregroundColor: light,
            ),
            onPressed: () async {
              await _auth.signOutFromApp();
            },
          )
        ],
      ),
      body: ListView(
        children: [
          durationSection,
          distanceAndPaceSection,
          // finishAndPauseButtonSection,
          startButtonSection,
          //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
        ],
      ),
      //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
      //     ElevatedButton(
      //   onPressed: () => setState(() => _showAppBar = !_showAppBar),
      //   child: const Text('Hide Appbar'),
      // ),
    );
  }
}
