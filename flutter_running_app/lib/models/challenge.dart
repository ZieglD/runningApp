import 'package:cloud_firestore/cloud_firestore.dart';

// Enum for time of day
enum TimeOfDay {
  morning,
  afternoon,
  evening,
  night,
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final double goalDistance;
  final double goalTotalDistance;
  final int? goalDuration;
  final double? goalPace;
  final String badgeID;
  bool isCompleted;
  // Time-of-day challenge flags
  final bool isMorningChallenge;
  final bool isAfternoonChallenge;
  final bool isEveningChallenge;
  final bool isNightChallenge;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.goalDistance,
    required this.goalTotalDistance,
    required this.goalDuration,
    required this.goalPace,
    required this.badgeID,
    required this.isCompleted,
    this.isMorningChallenge = false,
    this.isAfternoonChallenge = false,
    this.isEveningChallenge = false,
    this.isNightChallenge = false,
  });

  static TimeOfDay timeOfDayFromDate(DateTime dateTime) {
    if (dateTime.hour >= 5 && dateTime.hour < 12) {
      return TimeOfDay.morning;
    } else if (dateTime.hour >= 12 && dateTime.hour < 17) {
      return TimeOfDay.afternoon;
    } else if (dateTime.hour >= 17 && dateTime.hour < 21) {
      return TimeOfDay.evening;
    } else {
      return TimeOfDay.night;
    }
  }

  // Method to determine if an activity's time matches this challenge
  bool matchesTimeOfDay(TimeOfDay time) {
    //print('Checking time of day: $time');
    switch (time) {
      case TimeOfDay.morning:
        //print('isMorningChallenge: $isMorningChallenge');
        return isMorningChallenge;
      case TimeOfDay.afternoon:
        //print('isAfternoonChallenge: $isAfternoonChallenge');
        return isAfternoonChallenge;
      case TimeOfDay.evening:
        //print('isEveningChallenge: $isEveningChallenge');
        return isEveningChallenge;
      case TimeOfDay.night:
        //print('isNightChallenge: $isNightChallenge');
        return isNightChallenge;
      default:
        return false;
    }
  }

  // factory Challenge.fromMap(Map<String, dynamic> data, String id) {
  factory Challenge.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Use the ternary operator to check if the field is an int, and if so, convert it to double
    final goalDistance = data['goalDistance'] is int
        ? (data['goalDistance'] as int).toDouble()
        : data['goalDistance'];

    final goalTotalDistance = data['goalTotalDistance'] is int
        ? (data['goalTotalDistance'] as int).toDouble()
        : data['goalTotalDistance'];

    final int? goalDuration = data['goalDuration'] != null
        ? (data['goalDuration'] as num).toInt()
        : null;
    final double? goalPace = data['goalPace']?.toDouble();

    return Challenge(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      goalDistance: goalDistance ?? 0.0, // Provide a default value if it's null
      goalTotalDistance: goalTotalDistance ?? 0.0,
      goalDuration: goalDuration,
      goalPace: goalPace,
      badgeID: data['badgeID'] ?? 'No badgeID',
      isCompleted: data['isCompleted'] ?? false,
      isMorningChallenge: data['isMorningChallenge'] ?? false,
      isAfternoonChallenge: data['isAfternoonChallenge'] ?? false,
      isEveningChallenge: data['isEveningChallenge'] ?? false,
      isNightChallenge: data['isNightChallenge'] ?? false,
    );
  }
}
