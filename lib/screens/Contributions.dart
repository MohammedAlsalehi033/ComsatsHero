import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comsats_hero/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/Cards.dart';

class ContributionsScreen extends StatefulWidget {
  ContributionsScreen({super.key});

  @override
  _ContributionsScreenState createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> with SingleTickerProviderStateMixin {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<QueryDocumentSnapshot> otherChampions = [];
  QueryDocumentSnapshot? currentUserChampion;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _loadChampions();
  }

  void _loadChampions() async {
    UserService.getChampions().listen((QuerySnapshot snapshot) {
      setState(() {
        otherChampions.clear();
        currentUserChampion = null;

        for (var champion in snapshot.docs) {
          var championData = champion.data() as Map<String, dynamic>;
          if (championData['email'] == currentUser!.email) {
            currentUserChampion = champion;
          } else {
            otherChampions.add(champion);
          }
        }

        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [SizedBox(height: 10),Text("Top 10 contributors",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Expanded(
            child: CustomScrollView(
              slivers: [
                if (currentUserChampion != null)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      child: MyCards.cardForChampionUser(
                        displayName: (currentUserChampion!.data() as Map<String, dynamic>)['displayName'] ?? 'N/A',
                        rank: (currentUserChampion?.data() as Map<String, dynamic>)['rank'] ?? 0,
                        rollNumber: (currentUserChampion?.data() as Map<String, dynamic>)['rollNumber'] ?? 'N/A',
                        email: (currentUserChampion?.data() as Map<String, dynamic>)['email'] ?? 'N/A',
                        index: -1,
                        context: context,
                        isCurrentUser: true,
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      var champion = otherChampions[index].data() as Map<String, dynamic>;
                      return SizeTransition(
                        sizeFactor: _animation,
                        child: MyCards.cardForChampionUser(
                          displayName: champion['displayName'] ?? 'N/A',
                          rank: champion['rank'] ?? 0,
                          rollNumber: champion['rollNumber'] ?? 'N/A',
                          email: champion['email'] ?? 'N/A',
                          index: index,
                          context: context,
                          isCurrentUser: false,
                        ),
                      );
                    },
                    childCount: otherChampions.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 100.0;

  @override
  double get maxExtent => 100.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

