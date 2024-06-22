import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/models/users.dart';
import 'package:flutter/material.dart';

import '../widgets/Cards.dart';

class ContributionsScreen extends StatelessWidget {
  const ContributionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Champions List'),
        centerTitle: true,
        leading: Icon(Icons.grade),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: UserService.getChampions(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final champions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: champions.length,
            itemBuilder: (context, index) {
              var champion = champions[index].data() as Map<String, dynamic>;

              return MyCards.cardForChampionUser(
                displayName: champion['displayName'] ?? 'N/A',
                rank: champion['rank'] ?? 0,
                rollNumber: champion['rollNumber'] ?? 'N/A',
                email: champion['email'] ?? 'N/A',
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
