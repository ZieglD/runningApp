import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/badge.dart';
import '../../services/database.dart';

class BadgesGrid extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  final DatabaseService _firestoreService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Badge>>(
      stream: _firestoreService.getUserBadgesStream(user!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child:
                Text('Error: ${snapshot.error?.toString() ?? 'Unknown error'}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No badges found.'));
        }

        List<Badge> badges = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            Badge badge = badges[index];
            return Opacity(
              opacity: badge.isEarned
                  ? 1.0
                  : 0.5, // Full opacity if earned, otherwise half opacity
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
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
    );
  }
}
