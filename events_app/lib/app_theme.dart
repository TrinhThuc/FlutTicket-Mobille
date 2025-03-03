import 'package:events_app/app_utils.dart';
import 'package:flutter/material.dart';

String _appTheme = "lightCode";

LightCodeColors get appTheme => ThemeHelper().themeColor();

ThemeData get theme => ThemeHelper().themeData();

extension on TextStyle {}

class CustomTextStyles {
// Body text style

  static TextStyle get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );

  static TextStyle get bodyLargeBlack900_1 =>
      theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );

  static TextStyle get bodyLargeGray100 => theme.textTheme.bodyLarge!
      .copyWith(color: appTheme.gray100.withOpacity(0.75));

  static TextStyle get bodyLargeGray400 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray400,
      );

  static TextStyle get bodyLargeGray600 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray600,
      );

  static TextStyle get bodyMediumWhiteA700 =>
      theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.whiteA700,
      );

  static TextStyle get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );

  static TextStyle get bodySmallGray600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
      );

  static TextStyle get bodySmallGray600_1 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
      );

  static TextStyle get bodySmallRed400 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red400,
      );

  static TextStyle get bodySmallWhiteA700 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.whiteA700,
      );

// Headline text style

  static TextStyle get headlineSmallBlack900 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.black900,
      );

  static TextStyle get titleLargeGray900 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray900,
      );

  static TextStyle get titleLargeWhiteA700 =>
      theme.textTheme.titleLarge!.copyWith(
        color: appTheme.whiteA700,
      );

  static TextStyle get titleMediumGray600 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get titleMediumGray600_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
      );

  static TextStyle get titleMediumGray900 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMediumGray900_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray900,
      );

  static TextStyle get titleMediumSemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMediumWhiteA700 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
      );

  static TextStyle get titleMediumWhiteA700Medium =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w500,
      );
}

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable

class ThemeHelper {
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }

  /// Returns the lightCode colors for the current theme.

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.

  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;

    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.gray600,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }

          return Colors.transparent;
        }),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }

          return Colors.transparent;
        }),
        side: BorderSide(
          color: appTheme.whiteA700,
          width: 1,
        ),
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
      ),
    );
  }

  LightCodeColors themeColor() => _getThemeColors();
  ThemeData themeData() => _getThemeData();
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.gray900,
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onError,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray900,
          fontSize: 12.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 63.fSize,
          fontFamily: 'Skia',
          fontWeight: FontWeight.w100,
        ),
        headlineSmall: TextStyle(
          color: appTheme.gray900,
          fontSize: 24.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          color: appTheme.blue800,
          fontSize: 12.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        labelSmall: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 9.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 20.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      );
}

class ColorSchemes {
  static final lightCodeColorScheme = const ColorScheme.light(
    primary: Color(0XFF0CCDAA),
    primaryContainer: Color(0XFF2E2E2E),
    secondaryContainer: Color(0XFF070707),
    errorContainer: Color(0XFFFF5F00),
    onError: Color(0XFFC0BCBC),
    onPrimary: Color(0XFF231F20),
    onPrimaryContainer: Color(0XFFFAFAFA),
    onSecondaryContainer: Color(0XFF4D4D4D),
  );
}

/// Class containing custom colors for a lightCode theme.

class LightCodeColors {
// Amber

  Color get amber800 => const Color(0XFFFC9012);

// Black

  Color get black900 => const Color(0XFF000000);

  Color get black90001 => const Color(0XFF010101);

// Blue

  Color get blue800 => const Color(0XFF2753C5);

// BlueGray

  Color get blueGray1003f => const Color(0X3FD6D6D6);

  Color get blueGray900 => const Color(0XFF333538);

// DeepOrange

  Color get deepOrangeA700 => const Color(0XFFF01717);

// Gray

  Color get gray100 => const Color(0XFFF2F2F2);

  Color get gray200 => const Color(0XFFE8E8E8);

  Color get gray20001 => const Color(0XFFE7E7E7);

  Color get gray2004c => const Color(0X4CECEBEB);

  Color get gray300 => const Color(0XFFE3E4E8);

  Color get gray400 => const Color(0XFFB1B1B1);

  Color get gray40001 => const Color(0XFFBDBDBD);

  Color get gray40002 => const Color(0XFFC8C8C8);

  Color get gray600 => const Color(0XFF7C7C7C);

  Color get gray900 => const Color(0XFF252627);

// Green

  Color get green500 => const Color(0XFF32D74B);

  Color get greenA400 => const Color(0XFF2FD869);

  Color get greenA700 => const Color(0XFF0DCDAA);

// LightBlue

  Color get lightBlue900 => const Color(0XFF00579F);

// Red

  Color get red400 => const Color(0XFFF24052);

  Color get redA700 => const Color(0XFFEB001B);

// White

  Color get whiteA700 => const Color(0XFFFFFFFF);

// Yellow

  Color get yellow800 => const Color(0XFFFAA61A);

  Color get yellow80001 => const Color(0XFFF79E1B);
}

class AppDecoration {
// Fill decorations

  static BoxDecoration get fillwhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );

// Global decorations
  static BoxDecoration get globalGrey => BoxDecoration(
        color: appTheme.gray100,
      );

  static BoxDecoration get globalGreylight => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
      );

  static BoxDecoration get globalPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );

  static BoxDecoration get globalWhite => BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.gray2004c,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      );

// Gradient decorations

  static BoxDecoration get gradientPrimaryContainerToBlack => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.12, 0),
          end: const Alignment(0.59, 0.23),
          colors: [theme.colorScheme.primaryContainer, appTheme.black900],
        ),
      );

  static BoxDecoration get outlineGray => BoxDecoration(
        border: Border.all(
          color: appTheme.gray100,
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
// Circle borders

  static BorderRadius get circleBorder52 => BorderRadius.circular(
        52.h,
      );

// Custom borders

  static BorderRadius get customBorderLR5 => BorderRadius.horizontal(
        right: Radius.circular(5.h),
      );

  static BorderRadius get customBorderTL10 => BorderRadius.vertical(
        top: Radius.circular(10.h),
      );

  static BorderRadius get customBorderTL30 => BorderRadius.vertical(
        top: Radius.circular(30.h),
      );

// Rounded borders

  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );

  static BorderRadius get roundedBorder14 => BorderRadius.circular(
        14.h,
      );
  static BorderRadius get roundedBorder4 => BorderRadius.circular(
        4.h,
      );
}
