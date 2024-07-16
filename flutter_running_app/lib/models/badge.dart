// import 'package:cloud_firestore/cloud_firestore.dart';

// class Badge {
//   final String id;
//   final String title;
//   final String description;
//   final String imageKey;
//   final bool isEarned;

//   Badge({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.imageKey,
//     this.isEarned = false,
//   });

//   factory Badge.fromMap(Map<String, dynamic> data, String id) {
//     return Badge(
//         id: id,
//         title: data['title'],
//         description: data['description'],
//         imageKey: data['imageKey'],
//         isEarned: data['isEarned'] ?? false,
//   }

//   static fromDocumentSnapshot(QueryDocumentSnapshot<Object?> doc) {}
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  final String id;
  final String title;
  final String description;
  final String imageKey;
  final bool isEarned;
  final DateTime? earnedDate; // Add this line

  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.imageKey,
    this.isEarned = false,
    this.earnedDate, // Add this line
  });

  factory Badge.fromMap(Map<String, dynamic> data, String id) {
    return Badge(
      id: id,
      title: data['title'],
      description: data['description'],
      imageKey: data['imageKey'],
      isEarned: data['isEarned'] ?? false,
      earnedDate: data['earnedDate']
          ?.toDate(), // Add this line, assuming 'earnedDate' is a Timestamp in Firestore
    );
  }

  // Convert the Badge instance to a Map. Useful for uploading data to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageKey': imageKey,
      'isEarned': isEarned,
      'earnedDate':
          earnedDate, // Firestore handles DateTime conversion to Timestamp
    };
  }

  static fromDocumentSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return Badge.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
