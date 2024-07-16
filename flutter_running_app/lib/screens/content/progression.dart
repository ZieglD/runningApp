import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_running_app/shared/constants.dart';

class DistanceProgressBar extends StatelessWidget {
  final double totalDistance; // Distance in meters

  DistanceProgressBar({required this.totalDistance});

  // Define the new requirements for each level in kilometers
  final List<double> levelRequirements = [
    1,
    4,
    10,
    20,
    40,
    70,
    110,
    160,
    220,
    290,
    370,
    460,
    560,
    670,
    790,
    920,
    1060,
    1210,
    1370,
    1540,
    1720,
    1910,
    2110,
    2320,
    2540
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the current level and progress
    int level = 0;
    double progressTowardsNextLevel = 0.0;
    double totalDistanceInKm =
        totalDistance / 1000.0; // Convert meters to kilometers
    double accumulatedDistance = 0.0; // Accumulate distance for previous levels

    // Find the current level based on the total distance
    for (var requirement in levelRequirements) {
      if (totalDistanceInKm < requirement) {
        progressTowardsNextLevel = totalDistanceInKm / requirement;
        break;
      }
      totalDistanceInKm -= requirement;
      accumulatedDistance += requirement;
      level++;
    }

    // Calculate the total requirement for the next level
    double totalRequirementForNextLevel = accumulatedDistance +
        (level < levelRequirements.length ? levelRequirements[level] : 0);

    // Display the progress bar with the current level and progress
    return LevelProgressBar(
      level: level,
      fillPercentage: progressTowardsNextLevel,
      progressForLevel: totalDistance / 1000.0, // Use the total distance in km
      distanceForNextLevel: totalRequirementForNextLevel,
    );
  }
}

// A widget to display the actual progress bar with levels and progress indication
class LevelProgressBar extends StatelessWidget {
  final int level;
  final double fillPercentage; // Value between 0 and 1
  final double progressForLevel; // Actual progress in kilometers
  final double
      distanceForNextLevel; // Required distance for the next level in kilometers

  LevelProgressBar({
    required this.level,
    required this.fillPercentage,
    required this.progressForLevel,
    required this.distanceForNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    // Formatting the progress and requirement as strings with appropriate units
    // String progressString = "${progressForLevel.toStringAsFixed(2)} km";
    // String requirementString = "${distanceForNextLevel.toStringAsFixed(2)} km";
    String progressString = "${progressForLevel.toStringAsFixed(2)} km";
    String requirementString = "${distanceForNextLevel.toStringAsFixed(2)} km";

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 4,
        //borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Level $level',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    progressString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Next: $requirementString',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: LinearProgressIndicator(
                  value: fillPercentage,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(success),
                  minHeight: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
