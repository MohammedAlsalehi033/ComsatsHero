import 'package:comsats_hero/screens/Contributions.dart';
import 'package:comsats_hero/screens/Search.dart';
import 'package:comsats_hero/screens/Settings.dart';
import 'package:comsats_hero/screens/verifiedPapers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/Colors.dart';
import 'profile.dart';
import 'upload.dart';

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
    ContributionsScreen(),
    VerifiedPapersScreen(),
    SettingsScreen()
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
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyArchive'),
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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _bottomNavBarItems,
        selectedItemColor: myColors.secondaryColor,
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
