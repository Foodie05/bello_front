import "package:cw_blog/frame/profile_mgr.dart";
import "package:flutter/material.dart";

class ThemeSwitch extends ChangeNotifier{
  bool _isDark=false;
  ThemeSwitch(){
    if(profile.isOpen!=true){
      initProfileBox();
    }
    while(profile.isOpen!=true){
      
    }
    if(profile.containsKey(darkModeKey)){
      _isDark=bool.parse(profile.get(darkModeKey));
    }else{
      profile.put(darkModeKey, _isDark.toString());
    }
  }
  bool get isDark=>_isDark;
  void switchTheme(){
    if(_isDark==false){
      _isDark=true;
      profile.put(darkModeKey, _isDark.toString());

    }else{
      _isDark=false;
      profile.put(darkModeKey, _isDark.toString());
    }
    notifyListeners();
  }
}

class MaterialTheme {


  const MaterialTheme();

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280773193),
      surfaceTint: Color(4280773193),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289589959),
      onPrimaryContainer: Color(4278198545),
      secondary: Color(4283327317),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291881174),
      onSecondaryContainer: Color(4278918933),
      tertiary: Color(4282147953),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4290767353),
      onTertiaryContainer: Color(4278198055),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294376436),
      onSurface: Color(4279704857),
      onSurfaceVariant: Color(4282403138),
      outline: Color(4285561202),
      outlineVariant: Color(4290824640),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086509),
      inversePrimary: Color(4287747500),
      primaryFixed: Color(4289589959),
      onPrimaryFixed: Color(4278198545),
      primaryFixedDim: Color(4287747500),
      onPrimaryFixedVariant: Color(4278473267),
      secondaryFixed: Color(4291881174),
      onSecondaryFixed: Color(4278918933),
      secondaryFixedDim: Color(4290104507),
      onSecondaryFixedVariant: Color(4281813822),
      tertiaryFixed: Color(4290767353),
      onTertiaryFixed: Color(4278198055),
      tertiaryFixedDim: Color(4288990684),
      onTertiaryFixedVariant: Color(4280437849),
      surfaceDim: Color(4292271061),
      surfaceBright: Color(4294376436),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981678),
      surfaceContainer: Color(4293586921),
      surfaceContainerHigh: Color(4293192419),
      surfaceContainerHighest: Color(4292863197),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278209839),
      surfaceTint: Color(4280773193),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282351966),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281550650),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284775019),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280174677),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283595400),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294376436),
      onSurface: Color(4279704857),
      onSurfaceVariant: Color(4282139967),
      outline: Color(4284047706),
      outlineVariant: Color(4285824374),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086509),
      inversePrimary: Color(4287747500),
      primaryFixed: Color(4282351966),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280576071),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284775019),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283130195),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283595400),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281950575),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292271061),
      surfaceBright: Color(4294376436),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981678),
      surfaceContainer: Color(4293586921),
      surfaceContainerHigh: Color(4293192419),
      surfaceContainerHighest: Color(4292863197),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278200343),
      surfaceTint: Color(4280773193),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278209839),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279379483),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281550650),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278199856),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280174677),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294376436),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280165920),
      outline: Color(4282139967),
      outlineVariant: Color(4282139967),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281086509),
      inversePrimary: Color(4290182097),
      primaryFixed: Color(4278209839),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203423),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281550650),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280103205),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280174677),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278202686),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292271061),
      surfaceBright: Color(4294376436),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293981678),
      surfaceContainer: Color(4293586921),
      surfaceContainerHigh: Color(4293192419),
      surfaceContainerHighest: Color(4292863197),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4287747500),
      surfaceTint: Color(4287747500),
      onPrimary: Color(4278204705),
      primaryContainer: Color(4278473267),
      onPrimaryContainer: Color(4289589959),
      secondary: Color(4290104507),
      onSecondary: Color(4280300841),
      secondaryContainer: Color(4281813822),
      onSecondaryContainer: Color(4291881174),
      tertiary: Color(4288990684),
      onTertiary: Color(4278465858),
      tertiaryContainer: Color(4280437849),
      onTertiaryContainer: Color(4290767353),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279178513),
      onSurface: Color(4292863197),
      onSurfaceVariant: Color(4290824640),
      outline: Color(4287271819),
      outlineVariant: Color(4282403138),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292863197),
      inversePrimary: Color(4280773193),
      primaryFixed: Color(4289589959),
      onPrimaryFixed: Color(4278198545),
      primaryFixedDim: Color(4287747500),
      onPrimaryFixedVariant: Color(4278473267),
      secondaryFixed: Color(4291881174),
      onSecondaryFixed: Color(4278918933),
      secondaryFixedDim: Color(4290104507),
      onSecondaryFixedVariant: Color(4281813822),
      tertiaryFixed: Color(4290767353),
      onTertiaryFixed: Color(4278198055),
      tertiaryFixedDim: Color(4288990684),
      onTertiaryFixedVariant: Color(4280437849),
      surfaceDim: Color(4279178513),
      surfaceBright: Color(4281678646),
      surfaceContainerLowest: Color(4278849292),
      surfaceContainerLow: Color(4279704857),
      surfaceContainer: Color(4279968029),
      surfaceContainerHigh: Color(4280691495),
      surfaceContainerHighest: Color(4281349682),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288010672),
      surfaceTint: Color(4287747500),
      onPrimary: Color(4278197005),
      primaryContainer: Color(4284259961),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290367935),
      onSecondary: Color(4278589967),
      secondaryContainer: Color(4286551686),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4289253857),
      onTertiary: Color(4278196513),
      tertiaryContainer: Color(4285437861),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279178513),
      onSurface: Color(4294442229),
      onSurfaceVariant: Color(4291087813),
      outline: Color(4288456093),
      outlineVariant: Color(4286416254),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292863197),
      inversePrimary: Color(4278604596),
      primaryFixed: Color(4289589959),
      onPrimaryFixed: Color(4278195466),
      primaryFixedDim: Color(4287747500),
      onPrimaryFixedVariant: Color(4278206246),
      secondaryFixed: Color(4291881174),
      onSecondaryFixed: Color(4278326539),
      secondaryFixedDim: Color(4290104507),
      onSecondaryFixedVariant: Color(4280695598),
      tertiaryFixed: Color(4290767353),
      onTertiaryFixed: Color(4278195226),
      tertiaryFixedDim: Color(4288990684),
      onTertiaryFixedVariant: Color(4279057224),
      surfaceDim: Color(4279178513),
      surfaceBright: Color(4281678646),
      surfaceContainerLowest: Color(4278849292),
      surfaceContainerLow: Color(4279704857),
      surfaceContainer: Color(4279968029),
      surfaceContainerHigh: Color(4280691495),
      surfaceContainerHighest: Color(4281349682),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293853169),
      surfaceTint: Color(4287747500),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288010672),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293853169),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290367935),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294311167),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4289253857),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279178513),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294245876),
      outline: Color(4291087813),
      outlineVariant: Color(4291087813),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292863197),
      inversePrimary: Color(4278202652),
      primaryFixed: Color(4289853132),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288010672),
      onPrimaryFixedVariant: Color(4278197005),
      secondaryFixed: Color(4292210139),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290367935),
      onSecondaryFixedVariant: Color(4278589967),
      tertiaryFixed: Color(4291096317),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4289253857),
      onTertiaryFixedVariant: Color(4278196513),
      surfaceDim: Color(4279178513),
      surfaceBright: Color(4281678646),
      surfaceContainerLowest: Color(4278849292),
      surfaceContainerLow: Color(4279704857),
      surfaceContainer: Color(4279968029),
      surfaceContainerHigh: Color(4280691495),
      surfaceContainerHighest: Color(4281349682),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
