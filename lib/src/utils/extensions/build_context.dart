import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  /// get device [size] information
  Size get size => MediaQuery.of(this).size;

  /// get [screenPadding]
  EdgeInsets get screenPadding => MediaQuery.of(this).padding;

  /// get current [colorScheme] data
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// get current [textTheme] data
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// get [devicePixelRatio]
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// check [isPortraitMode]
  bool get isPortraitMode =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// check [isLandscapeMode]
  bool get isLandscapeMode =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// get device themeMode or [brightness]
  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  /// to [push] page
  Future<void> push({required Widget page}) async {
    Navigator.push(this, MaterialPageRoute(builder: (context) => page));
  }
}
