import 'package:flutter/material.dart';

class MyColors with ChangeNotifier {
  Color _primaryColor = const Color(0xFF6200EE); // Purple
  Color _primaryColorLight = const Color(0xFFBB86FC); // Light Purple
  Color _primaryColorDark = const Color(0xFF3700B3); // Dark Purple

  Color _secondaryColor = const Color(0xFF03DAC6); // Teal
  Color _secondaryColorLight = const Color(0xFF66FFF9); // Light Teal
  Color _secondaryColorDark = const Color(0xFF00A896); // Dark Teal

  Color _accentColor = const Color(0xFFFFC107); // Amber
  Color _accentColorLight = const Color(0xFFFFF350); // Light Amber
  Color _accentColorDark = const Color(0xFFFFA000); // Dark Amber

  Color _backgroundColor = const Color(0xFFF5F5F5); // Light Grey
  Color _backgroundDarkColor = const Color(0xFF121212); // Dark Grey

  Color _textColorPrimary = const Color(0xFF212121); // Dark Grey (Primary Text)
  Color _textColorSecondary = const Color(0xFF757575); // Grey (Secondary Text)
  Color _textColorLight = const Color(0xFFFFFFFF); // White

  Color _errorColor = const Color(0xFFB00020); // Red
  Color _errorColorLight = const Color(0xFFEF5350); // Light Red

  Color _customGreen = const Color(0xFF4CAF50); // Green
  Color _customBlue = const Color(0xFF2196F3); // Blue
  Color _customYellow = const Color(0xFFFFEB3B); // Yellow
  Color _customOrange = const Color(0xFFFF9800); // Orange

  Color _grey = const Color(0xFF9E9E9E); // Grey
  Color _lightGrey = const Color(0xFFE0E0E0); // Light Grey
  Color _darkGrey = const Color(0xFF424242); // Dark Grey
  Color _black = const Color(0xFF000000); // Black
  Color _white = const Color(0xFFFFFFFF); // White

  Color get primaryColor => _primaryColor;
  Color get primaryColorLight => _primaryColorLight;
  Color get primaryColorDark => _primaryColorDark;

  Color get secondaryColor => _secondaryColor;
  Color get secondaryColorLight => _secondaryColorLight;
  Color get secondaryColorDark => _secondaryColorDark;

  Color get accentColor => _accentColor;
  Color get accentColorLight => _accentColorLight;
  Color get accentColorDark => _accentColorDark;

  Color get backgroundColor => _backgroundColor;
  Color get backgroundDarkColor => _backgroundDarkColor;

  Color get textColorPrimary => _textColorPrimary;
  Color get textColorSecondary => _textColorSecondary;
  Color get textColorLight => _textColorLight;

  Color get errorColor => _errorColor;
  Color get errorColorLight => _errorColorLight;

  Color get customGreen => _customGreen;
  Color get customBlue => _customBlue;
  Color get customYellow => _customYellow;
  Color get customOrange => _customOrange;

  Color get grey => _grey;
  Color get lightGrey => _lightGrey;
  Color get darkGrey => _darkGrey;
  Color get black => _black;
  Color get white => _white;

  void updateColors(ThemeData themeData) {
    _primaryColor = themeData.primaryColor;
    _primaryColorLight = themeData.primaryColorLight;
    _primaryColorDark = themeData.primaryColorDark;

    _secondaryColor = themeData.colorScheme.secondary;
    _secondaryColorLight = themeData.colorScheme.secondary.withOpacity(0.7);
    _secondaryColorDark = themeData.colorScheme.secondary.withOpacity(0.4);

    _accentColorLight = _accentColor.withOpacity(0.7);
    _accentColorDark = _accentColor.withOpacity(0.4);

    _backgroundDarkColor = themeData.colorScheme.background;

    _textColorPrimary = themeData.textTheme.displayLarge?.color ?? Colors.black;
    _textColorSecondary = themeData.textTheme.displaySmall?.color ?? Colors.grey;
    _textColorLight = themeData.textTheme.displayLarge?.color ?? Colors.white;

    _errorColor = Colors.red;
    _errorColorLight = Colors.red.withOpacity(0.7);

    _customGreen = Colors.green;
    _customBlue = Colors.blue;
    _customYellow = Colors.yellow;
    _customOrange = Colors.orange;

    _grey = Colors.grey;
    _lightGrey = Colors.grey.withOpacity(0.7);
    _darkGrey = Colors.grey.withOpacity(0.4);
    _black = Colors.black;
    _white = Colors.white;

    notifyListeners();
  }
}
