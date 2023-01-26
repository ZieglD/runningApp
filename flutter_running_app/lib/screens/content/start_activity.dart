import 'package:flutter/material.dart';
import 'package:flutter_running_app/screens/content/countdown.dart';
import 'package:flutter_running_app/services/auth.dart';
import 'package:flutter_running_app/shared/constants.dart';
import 'package:flutter_running_app/shared/map_widget.dart';
import 'package:geolocator/geolocator.dart';

class StartActivity extends StatefulWidget {
  const StartActivity({super.key});

  @override
  State<StartActivity> createState() => _StartActivityState();
}

class _StartActivityState extends State<StartActivity> {
  final AuthService _auth = AuthService();
  bool _showAppBar = true;

  @override
  Widget build(BuildContext context) {
    Future<Position> checkPermissions() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      return await Geolocator.getCurrentPosition();
    }

    Widget durationSection = Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 5,
        child: ColoredBox(
          color: primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Duration',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
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
                          '0.0',
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
                          '00:00',
                          style: TextStyle(
                            //fontWeight: FontWeight.normal,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget startButton = Align(
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
          onPressed: () {
            checkPermissions();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Countdown()));
          },
          icon: const Icon(
            Icons.play_arrow_sharp,
            color: secondary,
            size: 35,
          ),
          label: const Text(
            'Start Run',
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
        body: Stack(
          children: [
            const MapWidget(),
            Stack(
              children: [
                durationSection,
                //mapPreview,

                //distanceAndPaceSection,
                //finishAndPauseButtonSection,
                startButton,
                //startButtonSection,
                //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
              ],
            ),
          ],
        )

        //const Center(child: Text('Activity', style: TextStyle(fontSize: 60))),
        //     ElevatedButton(
        //   onPressed: () => setState(() => _showAppBar = !_showAppBar),
        //   child: const Text('Hide Appbar'),
        // ),
        );
  }
}
