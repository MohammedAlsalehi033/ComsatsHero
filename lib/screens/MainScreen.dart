import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/news.dart';
import '../theme/Colors.dart';
import 'profile.dart';
import 'upload.dart';
import 'Contributions.dart';
import 'Search.dart';
import 'TimeTableScreen.dart';
import 'verifiedPapers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String id = 'home_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SearchScreen(),
    TimeTableScreen(),
    ContributionsScreen(),
    VerifiedPapersScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.calendar_month_outlined),
      label: 'Exams Times',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Contributions',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.verified),
      label: 'Verified',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<String> newsList = [];
  int currentNewsIndex = 0;
  bool _showNews = false;
  late Timer _newsTimer;

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _newsTimer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (newsList.isNotEmpty) {
        setState(() {
          currentNewsIndex = (currentNewsIndex + 1) % newsList.length;
          _showNews = true;
        });

        Timer(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showNews = false;
            });
          }
        });
      }
    });
  }

  Future<void> _fetchNews() async {
    newsList = await news.getNews();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _newsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _showNews && newsList.isNotEmpty
              ? Text(
            newsList[currentNewsIndex],
            key: ValueKey<String>(newsList[currentNewsIndex]),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          )
              : Text(
            'Comsats Hero',
            key: ValueKey<String>('Comsats Hero'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColorLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _bottomNavBarItems,
        selectedItemColor: myColors.primaryColorLight,
        unselectedItemColor: myColors.grey,
        backgroundColor: myColors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myColors.primaryColorLight,
        child: Icon(Icons.upload_file, color: myColors.textColorLight),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
        },
      ),
      backgroundColor: myColors.backgroundColor,
    );
  }
}