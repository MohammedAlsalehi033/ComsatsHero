import 'package:comsats_hero/screens/Contributions.dart';
import 'package:comsats_hero/screens/Search.dart';
import 'package:comsats_hero/screens/photoTaker.dart';
import 'package:comsats_hero/screens/verifiedPapers.dart';
import 'package:flutter/material.dart';
import '../theme/Colors.dart';
import 'profile.dart';
import 'upload.dart';
import 'package:comsats_hero/screens/SignInTest.dart';
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
    const ContributionsScreen(),
    VerifiedPapersScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyArchive'),
        backgroundColor: MyColors.primaryColorLight,
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _bottomNavBarItems,
        selectedItemColor: MyColors.secondaryColor,
        unselectedItemColor: MyColors.grey,
        backgroundColor: MyColors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primaryColorLight,
        child: const Icon(Icons.upload_file, color: MyColors.textColorLight),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
        },
      ),
      backgroundColor: MyColors.backgroundColor,
    );
  }
}
