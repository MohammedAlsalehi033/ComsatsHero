import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../theme/Colors.dart';
import '../theme/Mythemes.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final myColors = Provider.of<MyColors>(context);

    void changeTheme(ThemeData theme) {
      themeProvider.setTheme(theme);
      myColors.updateColors(theme);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Theme',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => changeTheme(MyThemes.lightTheme),
              child: const Text('Light Theme'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeTheme(MyThemes.darkTheme),
              child: const Text('Dark Theme'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeTheme(MyThemes.greenTheme),
              child: const Text('Green Theme'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeTheme(MyThemes.redTheme),
              child: const Text('Red Theme'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeTheme(MyThemes.orangeTheme),
              child: const Text('Orange Theme'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => changeTheme(MyThemes.tealTheme),
              child: const Text('Teal Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
