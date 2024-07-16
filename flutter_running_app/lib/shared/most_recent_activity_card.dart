import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_running_app/models/activity.dart';
import 'package:flutter_running_app/services/database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/badge.dart';

class MostRecentActivityCard extends StatelessWidget {
  final DatabaseService databaseService;

  MostRecentActivityCard({required this.databaseService});

  String formatSeconds(num seconds, String unit) {
    int totalSeconds = seconds is int ? seconds : seconds.round();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int remainingSeconds = totalSeconds % 60;

    // Format the string based on whether there are hours or not
    String formattedTime = [
      if (hours != 0) hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
      remainingSeconds.toString().padLeft(2, '0')
    ].join(':');

    return '$formattedTime $unit';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Activity?>(
      future: databaseService.getMostRecentActivity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No recent activities found.'));
        }
        Activity activity = snapshot.data!;

        // Convert meters to kilometers with 2 decimal places
        double distanceInKm = activity.distance / 1000;
        String formattedDistance = '${distanceInKm.toStringAsFixed(2)} km';
        String formattedDuration =
            formatSeconds(activity.duration, "min"); // duration is an int
        String formattedPace =
            formatSeconds(activity.pace, "min/km"); // pace is a double

        // Format the date
        String formattedDate =
            DateFormat('EEEE, MMM d, yyyy').format(activity.date.toLocal());

        List<LatLng> points = activity.coordinates
            .map((coord) => LatLng(coord.latitude, coord.longitude))
            .toList();
        var bounds = LatLngBounds.fromPoints(points);

        return Column(
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your run on $formattedDate',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlutterMap(
                          options: MapOptions(
                            bounds: bounds,
                            boundsOptions: FitBoundsOptions(
                              padding: EdgeInsets.all(8.0),
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://api.mapbox.com/styles/v1/holigun/clawpw8ic00dm14o6pa6ml5gk/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
                              additionalOptions: {
                                "access_token":
                                    "pk.eyJ1IjoiaG9saWd1biIsImEiOiJja3NidXZqaGowYW9wMm9tYzNpYXBrMzEwIn0.purHnG1lh0oYwtM7bpwQFQ",
                              },
                            ),
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: points,
                                  strokeWidth: 4.0,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _ActivityStat(
                      value: formattedDistance,
                      label: 'Distance',
                      fontSize: 26,
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ActivityStat(
                          value: formattedDuration,
                          label: 'Duration',
                        ),
                        _ActivityStat(
                          value: formattedPace,
                          label: 'Pace',
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<Badge>>(
              future: databaseService.getBadgesEarnedDuringLastActivity(),
              builder: (context, badgesSnapshot) {
                if (badgesSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!badgesSnapshot.hasData || badgesSnapshot.data!.isEmpty) {
                  return Text('No badges earned during the last activity.');
                }
                List<Badge> badges = badgesSnapshot.data!;

                // Display the badges in a GridView
                return GridView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  //physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    Badge badge = badges[index];
                    return Opacity(
                      opacity: badge.isEarned ? 1.0 : 0.5,
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/badges/${badge.imageKey}.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                badge.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                badge.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _ActivityStat(
      {required String value, required String label, double fontSize = 18}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
