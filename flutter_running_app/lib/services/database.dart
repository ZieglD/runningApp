import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_running_app/models/challenge.dart';
import 'package:flutter_running_app/models/leaderboard_entry.dart';
import 'package:latlong2/latlong.dart';

import '../models/activity.dart';
import '../models/badge.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

  //user collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData() async {
    return await userCollection.doc(uid).set({
      // 'activityDistance': activityDistance,
    });
  }

  // Future updateActivities(
  //     String userID,
  //     double activityDistance,
  //     List<LatLng> activityCoordinates,
  //     Duration activityDuration,
  //     Duration activityPace,
  //     DateTime date) async {
  //   List<Map<String, dynamic>> coordinatesMapList =
  //       activityCoordinates.map((latLng) => latLng.toJson()).toList();

  //   return await FirebaseFirestore.instance
  //       .collection('activities')
  //       .doc(uid)
  //       .collection('userActivities')
  //       .add({
  //     'userID': userID,
  //     'activityDistance': activityDistance,
  //     'activityCoordinates': coordinatesMapList,
  //     'activityDuration': activityDuration.inSeconds,
  //     'activityPace': activityPace.inSeconds,
  //     'date': date,
  //   });
  // }

  Future updateActivities(
      String userID,
      double activityDistance,
      List<LatLng> activityCoordinates,
      Duration activityDuration,
      Duration activityPace,
      DateTime date) async {
    try {
      List<Map<String, dynamic>> coordinatesMapList =
          activityCoordinates.map((latLng) => latLng.toJson()).toList();

      return await FirebaseFirestore.instance
          .collection('activities')
          .doc(userID)
          .collection('userActivities')
          .add({
        'userID': userID,
        'activityDistance': activityDistance,
        'activityCoordinates': coordinatesMapList,
        'activityDuration': activityDuration.inSeconds,
        'activityPace': activityPace.inSeconds,
        'date': date,
      });
    } catch (e) {
      print('An error occurred while updating activities: $e');
      // Handle the error accordingly
    }
  }

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
        print('fetched distance ${data.get('activityDistance')}');
      }
    });
  }

  // get total distance for displaying progress bar
  // gets all individual acitivity distances of a user and sums them up
  Future<double> getTotalActivityDistance() async {
    double totalDistance = 0.0;

    try {
      // Reference to the user's activities collection
      var activitiesRef = FirebaseFirestore.instance
          .collection('activities')
          .doc(uid)
          .collection('userActivities');

      // Get the documents
      var querySnapshot = await activitiesRef.get();

      // Calculate the total distance
      querySnapshot.docs.forEach((doc) {
        double distance = doc.data()['activityDistance']?.toDouble() ?? 0.0;
        totalDistance += distance;
      });
    } on FirebaseException catch (e) {
      print('Error getting activities: $e');
      // Handle the error or throw an exception
    }
    // print('test total distance:');
    // print(totalDistance);
    return totalDistance;
  }

  Future<void> initializeUserChallenges() async {
    final List<Map<String, dynamic>> challengesData = [
      {
        'title': 'Complete your first activity',
        'description':
            'Achieve this milestone by completing your first activity',
        'goalDistance': 0.0,
        'goalTotalDistance': double.maxFinite,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_001',
        'isCompleted': false,
      },
      {
        'title': 'Your first 1km Activity',
        'description':
            'Challenge yourself to run a distance of 1km in a single activity',
        'goalDistance': 1000.0,
        'goalTotalDistance': double.maxFinite,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_002',
        'isCompleted': false,
      },
      {
        'title': 'Your first 5km Activity',
        'description':
            'Challenge yourself to run a distance of 5km in a single activity',
        'goalDistance': 5000.0,
        'goalTotalDistance': double.maxFinite,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_003',
        'isCompleted': false,
      },
      {
        'title': 'Your first 10km Activity',
        'description':
            'Challenge yourself to run a distance of 10km in a single activity',
        'goalDistance': 10000.0,
        'goalTotalDistance': double.maxFinite,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_004',
        'isCompleted': false,
      },
      {
        'title': 'Half Marathon Runner',
        'description':
            'Challenge yourself to run a Half Marathon (21,097km) in a single activity',
        'goalDistance': 21097.0,
        'goalTotalDistance': double.maxFinite,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_005',
        'isCompleted': false,
      },
      {
        'title': 'Marathon Runner',
        'description':
            'Challenge yourself to run a Marathon in (42,195km) a single activity',
        'goalDistance': 42195.0,
        'goalTotalDistance': double.maxFinite,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_006',
        'isCompleted': false,
      },

      {
        'title': 'Reach Level 1',
        'description': 'Challenge yourself to reach level 1 (1km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 1000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_007',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 2',
        'description': 'Challenge yourself to reach level 2 (4km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 4000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_008',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 3',
        'description': 'Challenge yourself to reach level 3 (10km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 10000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_009',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 4',
        'description': 'Challenge yourself to reach level 4 (20km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 20000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_010',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 5',
        'description': 'Challenge yourself to reach level 5 (40km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 40000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_011',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 10',
        'description': 'Challenge yourself to reach level 10 (290km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 290000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_012',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 15',
        'description': 'Challenge yourself to reach level 15 (790km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 790000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_013',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 20',
        'description': 'Challenge yourself to reach level 20 (1.540km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 1540000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_014',
        'isCompleted': false,
      },
      {
        'title': 'Reach Level 25',
        'description': 'Challenge yourself to reach level 25 (2.540km)',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': 2540000.0,
        // 'goalDuration': 100000,
        // 'goalPace': double.maxFinite,
        'badgeID': 'badge_015',
        'isCompleted': false,
      },
      {
        'title': '15 Minute Runner',
        'description':
            'Finish an activity with a duration of at least 15 minutes',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'goalDuration': 900,
        'badgeID': 'badge_016',
        'isCompleted': false,
      },
      {
        'title': '30 Minute Runner',
        'description':
            'Finish an activity with a duration of at least 30 minutes',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'goalDuration': 1800,
        'badgeID': 'badge_017',
        'isCompleted': false,
      },
      {
        'title': '60 Minute Runner',
        'description':
            'Finish an activity with a duration of at least 60 minutes',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'goalDuration': 3600,
        'badgeID': 'badge_018',
        'isCompleted': false,
      },
      {
        'title': 'Speedster',
        'description': 'Complete an activity with a pace of 4 minutes per km.',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'goalPace': 240,
        'badgeID': 'badge_019',
        'isCompleted': false,
      },
      {
        'title': 'Early Bird Run',
        'description': 'Complete an activity in the morning',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'isMorningChallenge': true,
        'badgeID': 'badge_020',
        'isCompleted': false,
      },
      {
        'title': 'Afternoon Runner',
        'description': 'Complete an activity in the afternoon',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'isAfternoonChallenge': true,
        'badgeID': 'badge_021',
        'isCompleted': false,
      },
      {
        'title': 'Evening Runner',
        'description': 'Complete an activity in the evening',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'isEveningChallenge': true,
        'badgeID': 'badge_022',
        'isCompleted': false,
      },
      {
        'title': 'Night Runner',
        'description': 'Complete an activity in the night',
        'goalDistance': double.maxFinite,
        'goalTotalDistance': double.maxFinite,
        'isNightChallenge': true,
        'badgeID': 'badge_023',
        'isCompleted': false,
      },
      // Add other initial challenges...
    ];

    final List<String> challengeIds = [
      'challenge_001',
      'challenge_002',
      'challenge_003',
      'challenge_004',
      'challenge_005',
      'challenge_006',
      'challenge_007',
      'challenge_008',
      'challenge_009',
      'challenge_010',
      'challenge_011',
      'challenge_012',
      'challenge_013',
      'challenge_014',
      'challenge_015',
      'challenge_016',
      'challenge_017',
      'challenge_018',
      'challenge_019',
      'challenge_020',
      'challenge_021',
      'challenge_022',
      'challenge_023',
    ];

    final CollectionReference userChallenges = FirebaseFirestore.instance
        .collection('activities')
        .doc(uid)
        .collection('userChallenges');

    final batch = FirebaseFirestore.instance.batch();

    for (int i = 0; i < challengesData.length; i++) {
      // Use the predefined challenge ID instead of an auto-generated ID
      DocumentReference docRef = userChallenges.doc(challengeIds[i]);
      batch.set(docRef, challengesData[i]);
    }

    await batch.commit();
  }

  // Stream for listing all available challenges in the challenges_list widget
  Stream<List<Challenge>> getUserChallenges(String userId) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(userId)
        .collection('userChallenges')
        .snapshots()
        .map((snapshot) {
      //print('Challenges found: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        //print('No documents in challenges collection');
      }
      return snapshot.docs
          .map((doc) => Challenge.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Fetches current challenges for user
  Future<List<Challenge>> fetchUserChallenges(String userId) async {
    List<Challenge> challenges = [];
    try {
      QuerySnapshot challengeSnapshot = await FirebaseFirestore.instance
          .collection('activities')
          .doc(userId)
          .collection('userChallenges')
          .get();

      challenges = challengeSnapshot.docs
          .map((doc) => Challenge.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print("Error fetching challenges: $e");
      // Handle the error appropriately.
    }
    return challenges;
  }

  //The updated checkAndCompleteChallenges function
  Future<void> checkAndCompleteChallenges(
      String userId,
      double activityDistance,
      int activityDuration,
      double activityPace,
      DateTime date) async {
    try {
      List<Challenge> userChallenges = await fetchUserChallenges(userId);
      DatabaseService dbService = DatabaseService(uid: userId);
      double totalDistance = await dbService.getTotalActivityDistance();
      TimeOfDay activityTimeOfDay = Challenge.timeOfDayFromDate(date);
      List<Challenge> completedChallenges = [];

      for (var challenge in userChallenges) {
        //bool isChallengeCompleted = false;

        // Check for distance-based challenges
        if (!challenge.isCompleted &&
            activityDistance >= challenge.goalDistance) {
          challenge.isCompleted = true; // Update local state
          completedChallenges
              .add(challenge); // Add to list of completed challenges
        }
        // Check for total distance challenges (now independent of the activityDistance check)
        if (!challenge.isCompleted &&
            totalDistance >= challenge.goalTotalDistance) {
          challenge.isCompleted = true; // Update local state
          completedChallenges
              .add(challenge); // Add to list of completed challenges
        }

        // Check for duration-based challenges
        if (!challenge.isCompleted &&
            challenge.goalDuration != null &&
            activityDuration >= challenge.goalDuration!) {
          challenge.isCompleted = true;
        }

        // Check for pace-based challenges
        if (!challenge.isCompleted &&
            challenge.goalPace != null &&
            activityPace <= challenge.goalPace!) {
          challenge.isCompleted = true;
        }

        // Check if the challenge is a time-of-day challenge and if it matches the activity time of day
        if (!challenge.isCompleted &&
            challenge.matchesTimeOfDay(activityTimeOfDay)) {
          challenge.isCompleted = true;
          print(
              'Completing ${activityTimeOfDay.toString().split('.').last} challenge.');
        }

        // if (!challenge.isCompleted &&
        //     challenge.isAfternoonChallenge &&
        //     activityTimeOfDay == TimeOfDay.afternoon) {
        //   challenge.isCompleted = true;
        //   print('Completing afternoon challenge.');
        // }

        // if (!challenge.isCompleted &&
        //     challenge.isEveningChallenge &&
        //     activityTimeOfDay == TimeOfDay.evening) {
        //   challenge.isCompleted = true;
        //   print('Completing evening challenge.');
        // }

        // if (!challenge.isCompleted &&
        //     challenge.isNightChallenge &&
        //     activityTimeOfDay == TimeOfDay.night) {
        //   challenge.isCompleted = true;
        //   print('Completing night challenge.');
        // }

        // If any challenge is completed, award the badge
        if (challenge.isCompleted && challenge.badgeID.isNotEmpty) {
          await awardBadge(userId, challenge.badgeID, date);
        }
      }

      // Update the completed challenges in Firestore
      await updateChallenges(userId, completedChallenges);
    } catch (e) {
      print('Error while checking and completing: $e');
    }
  }

  // updates the firestore challenge entries if challenges are completed
  Future<void> updateChallenges(
      String userId, List<Challenge> completedChallenges) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var challenge in completedChallenges) {
      DocumentReference challengeRef = FirebaseFirestore.instance
          .collection('activities')
          .doc(userId)
          .collection('userChallenges')
          .doc(challenge.id);

      batch.update(challengeRef, {'isCompleted': true});
    }

    await batch.commit();
  }

  // Initially creates badges. This function is used in the sign up function
  Future<void> initializeUserBadges() async {
    final List<Map<String, dynamic>> badgesData = [
      {
        'title': 'First Activity',
        'description': 'Awarded for completing your first activity',
        'imageKey': 'badge_001',
        'isEarned': false,
      },
      {
        'title': '1km Run',
        'description': 'Awarded for completing a 1km run',
        'imageKey': 'badge_002',
        'isEarned': false,
      },
      {
        'title': '5km Run',
        'description': 'Awarded for completing a 5km run',
        'imageKey': 'badge_003',
        'isEarned': false,
      },
      {
        'title': '10km Run',
        'description': 'Awarded for completing a 10km run',
        'imageKey': 'badge_004',
        'isEarned': false,
      },
      {
        'title': 'Half Marathon',
        'description': 'Awarded for completing a Half Marathon (21,097km)',
        'imageKey': 'badge_005',
        'isEarned': false,
      },
      {
        'title': 'Marathon',
        'description': 'Awarded for completing a Marathon (41,195km)',
        'imageKey': 'badge_006',
        'isEarned': false,
      },
      {
        'title': 'Level 1',
        'description': 'Awarded for reaching level 1',
        'imageKey': 'badge_007',
        'isEarned': false,
      },
      {
        'title': 'Level 2',
        'description': 'Awarded for reaching level 2',
        'imageKey': 'badge_008',
        'isEarned': false,
      },
      {
        'title': 'Level 3',
        'description': 'Awarded for reaching level 3',
        'imageKey': 'badge_009',
        'isEarned': false,
      },
      {
        'title': 'Level 4',
        'description': 'Awarded for reaching level 4',
        'imageKey': 'badge_010',
        'isEarned': false,
      },
      {
        'title': 'Level 5',
        'description': 'Awarded for reaching level 5',
        'imageKey': 'badge_011',
        'isEarned': false,
      },
      {
        'title': 'Level 10',
        'description': 'Awarded for reaching level 10',
        'imageKey': 'badge_012',
        'isEarned': false,
      },
      {
        'title': 'Level 15',
        'description': 'Awarded for reaching level 15',
        'imageKey': 'badge_013',
        'isEarned': false,
      },
      {
        'title': 'Level 20',
        'description': 'Awarded for reaching level 20',
        'imageKey': 'badge_014',
        'isEarned': false,
      },
      {
        'title': 'Level 25',
        'description': 'Awarded for reaching level 25',
        'imageKey': 'badge_015',
        'isEarned': false,
      },
      {
        'title': '15 Minute Run',
        'description': 'Awarded for completing a 15 minute run',
        'imageKey': 'badge_016',
        'isEarned': false,
      },
      {
        'title': '30 Minute Run',
        'description': 'Awarded for completing a 30 minute run',
        'imageKey': 'badge_017',
        'isEarned': false,
      },
      {
        'title': '60 Minute Run',
        'description': 'Awarded for completing a 60 minute run',
        'imageKey': 'badge_018',
        'isEarned': false,
      },
      {
        'title': 'Speedster',
        'description': 'Awarded for completing a run with a pace of 4 min/km',
        'imageKey': 'badge_019',
        'isEarned': false,
      },
      {
        'title': 'Early Bird Run',
        'description': 'Awarded for completing a morning run',
        'imageKey': 'badge_020',
        'isEarned': false,
      },
      {
        'title': 'Afternoon Runner',
        'description': 'Awarded for completing an afternoon run',
        'imageKey': 'badge_021',
        'isEarned': false,
      },
      {
        'title': 'Evening Runner',
        'description': 'Awarded for completing an evening run',
        'imageKey': 'badge_022',
        'isEarned': false,
      },
      {
        'title': 'Night Runner',
        'description': 'Awarded for completing a night run',
        'imageKey': 'badge_023',
        'isEarned': false,
      },
      // ... other badges
    ];

    final List<String> badgeIds = [
      'badge_001',
      'badge_002',
      'badge_003',
      'badge_004',
      'badge_005',
      'badge_006',
      'badge_007',
      'badge_008',
      'badge_009',
      'badge_010',
      'badge_011',
      'badge_012',
      'badge_013',
      'badge_014',
      'badge_015',
      'badge_016',
      'badge_017',
      'badge_018',
      'badge_019',
      'badge_020',
      'badge_021',
      'badge_022',
      'badge_023',
    ];

    final CollectionReference userBadges = FirebaseFirestore.instance
        .collection('activities')
        .doc(uid)
        .collection('userBadges');

    final WriteBatch batch = FirebaseFirestore.instance.batch();

    for (int i = 0; i < badgesData.length; i++) {
      DocumentReference docRef = userBadges.doc(badgeIds[i]);
      batch.set(docRef, {
        'title': badgesData[i]['title'],
        'description': badgesData[i]['description'],
        'imageKey': badgesData[i]['imageKey'],
        'isEarned': badgesData[i]['isEarned'],
      });
    }

    await batch.commit();
  }

  // Used to switch the status of the badge to isEarned
  // Future<void> awardBadge(String userId, String badgeID) async {
  //   DocumentReference badgeRef = FirebaseFirestore.instance
  //       .collection('activities')
  //       .doc(userId)
  //       .collection('userBadges')
  //       .doc(badgeID);

  //   return badgeRef.update({'isEarned': true});
  // }

  // Future<void> awardBadge(
  //     String userId, String badgeID, DateTime earnedDate) async {
  //   DocumentReference badgeRef = FirebaseFirestore.instance
  //       .collection('activities')
  //       .doc(userId)
  //       .collection('userBadges')
  //       .doc(badgeID);

  //   return badgeRef.update({
  //     'isEarned': true,
  //     'earnedDate':
  //         earnedDate, // Firestore will automatically convert this to a Timestamp
  //   });
  // }

  Future<void> awardBadge(
      String userId, String badgeID, DateTime earnedDate) async {
    DocumentReference badgeRef = FirebaseFirestore.instance
        .collection('activities')
        .doc(userId)
        .collection('userBadges')
        .doc(badgeID);

    // Fetch the current badge data
    DocumentSnapshot badgeSnapshot = await badgeRef.get();
    if (badgeSnapshot.exists) {
      Badge badge = Badge.fromMap(
          badgeSnapshot.data() as Map<String, dynamic>, badgeSnapshot.id);
      // Only update the badge if it hasn't been earned before
      if (!badge.isEarned) {
        return badgeRef.update({
          'isEarned': true,
          'earnedDate':
              earnedDate, // Firestore will automatically convert this to a Timestamp
        });
      }
    }
  }

  // Fetches badges associated with users from firestore
  // is used for displaying locked and unlocked badged in the badges grid widget
  Stream<List<Badge>> getUserBadgesStream(String userId) {
    // This stream should fetch the badges data from Firestore
    // Adjust the path according to your Firestore structure
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(userId)
        .collection('userBadges')
        .snapshots()
        .map((snapshot) {
      //print('Badges found: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        print('No documents in badges collection');
      }
      return snapshot.docs
          .map((doc) =>
              Badge.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // ... existing DatabaseService class ...

  Stream<List<Activity>> getUserActivitiesStream() {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(uid)
        .collection('userActivities')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList());
  }

  Future<Activity?> getMostRecentActivity() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('activities')
          .doc(uid)
          .collection('userActivities')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Activity.fromFirestore(snapshot.docs.first);
      }
    } catch (e) {
      print("Error fetching most recent activity: $e");
    }
    return null;
  }

  Future<List<Badge>> getBadgesEarnedDuringLastActivity() async {
    List<Badge> earnedBadges = [];
    Activity? mostRecentActivity = await getMostRecentActivity();

    if (mostRecentActivity == null) {
      return earnedBadges; // Return empty list if there's no recent activity
    }

    try {
      var badgesSnapshot = await FirebaseFirestore.instance
          .collection('activities')
          .doc(uid)
          .collection('userBadges')
          .where('isEarned', isEqualTo: true)
          .where('earnedDate', isEqualTo: mostRecentActivity.date)
          .get();

      earnedBadges = badgesSnapshot.docs
          .map((doc) =>
              Badge.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching badges for last activity: $e");
    }
    return earnedBadges;
  }
}
