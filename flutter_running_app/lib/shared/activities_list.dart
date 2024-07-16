import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_running_app/models/activity.dart';
import 'package:flutter_running_app/services/database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ActivitiesList extends StatelessWidget {
  final DatabaseService databaseService;

  ActivitiesList({required this.databaseService});

  String formatDuration(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedTime = [
      if (hours > 0) hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
      seconds.toString().padLeft(2, '0'),
    ].join(':');

    return "$formattedTime min";
  }

  String formatPace(double secondsPerKm) {
    int minutes = secondsPerKm ~/ 60;
    int seconds = (secondsPerKm % 60).round();

    String formattedPace = [
      minutes.toString().padLeft(2, '0'),
      seconds.toString().padLeft(2, '0'),
    ].join(':');

    return "$formattedPace min/km";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Activity>>(
      stream: databaseService.getUserActivitiesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('Start your first activity to view the history!'));
        }

        List<Activity> activities = snapshot.data!;

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            Activity activity = activities[index];
            var points = activity.coordinates
                .map((coord) => LatLng(coord.latitude, coord.longitude))
                .toList();

            LatLngBounds bounds = LatLngBounds.fromPoints(points);

            String formattedDistance =
                '${(activity.distance / 1000).toStringAsFixed(2)} km';
            // Use the formatDuration and formatPace methods to format the duration and pace
            String formattedDuration = formatDuration(activity.duration);
            String formattedPace = formatPace(activity.pace);
            String formattedDate = DateFormat('EEEE, MMM d, yyyy - h:mm a')
                .format(activity.date.toLocal());

            return Card(
              elevation: 4,
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Center align the header and other text
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center, // Center the header
                    ),
                  ),
                  if (points.isNotEmpty)
                    Container(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          bounds: bounds,
                          boundsOptions: FitBoundsOptions(
                            padding: EdgeInsets.all(8.0),
                          ),
                          zoom: 13.0,
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
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      formattedDistance,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center, // Center the distance
                    ),
                  ),
                  Text(
                    'Distance',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center, // Center the distance label
                  ),
                  Divider(), // Divider between distance and duration/pace
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Horizontally center duration and pace
                      children: [
                        Column(
                          children: [
                            Text(
                              formattedDuration,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: 24), // Add space between duration and pace
                        Column(
                          children: [
                            Text(
                              formattedPace,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Pace',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0), // Padding below duration and pace
                    child:
                        Container(), // This container serves as a placeholder for padding
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
