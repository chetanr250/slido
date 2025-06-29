import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final darkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xff9fc9ff),
    primaryContainer: Color(0xff00325b),
    secondary: Color(0xffffb59d),
    secondaryContainer: Color(0xff872100),
    tertiary: Color(0xff86d2e1),
    tertiaryContainer: Color(0xff004e59),
    appBarColor: Color(0xff872100),
    error: Color(0xffcf6679),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    // useInputDecoratorThemeInDialogs: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // textTheme: GoogleFonts.robotoTextTheme(),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.withOpacity(0.18),
      side: BorderSide(
          style: BorderStyle.solid,
          color: Colors.blue.withOpacity(0.5),
          width: 2),
    ),
  ),
);
final lightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff004881),
    primaryContainer: Color(0xffd0e4ff),
    secondary: Color(0xffac3306),
    secondaryContainer: Color(0xffffdbcf),
    tertiary: Color(0xff006875),
    tertiaryContainer: Color(0xff95f0ff),
    appBarColor: Color(0xffffdbcf),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    // useInputDecoratorThemeInDialogs: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.withOpacity(0.18),
      side: BorderSide(
          style: BorderStyle.solid,
          color: Colors.blue.withOpacity(0.5),
          width: 2),
    ),
  ),
);
const List<String> modes = ['question', 'answer', 'selections'];
final warningButtonStyle = ButtonStyle(
  side: MaterialStateProperty.all(
    const BorderSide(color: Colors.white, width: 1),
  ),
  backgroundColor: MaterialStateProperty.all(Colors.red),
);
RoundedRectangleBorder cardStyle(BuildContext context) =>
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(
        color: Theme.of(context).colorScheme.primaryContainer,
        width: 2,
      ),
    );
ButtonStyle buttonStyle(BuildContext context) => ElevatedButton.styleFrom(
      backgroundColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      side: BorderSide(
          style: BorderStyle.solid,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          width: 2),
    );
