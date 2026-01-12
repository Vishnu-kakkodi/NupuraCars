// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color _seedColor = Color(0xFF00BFA5); // Teal-ish brand color

//   /// Light Theme
//   static ThemeData get lightTheme {
//     final base = ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: _seedColor,
//         brightness: Brightness.light,
//       ),
//     );

//     return base.copyWith(
//       scaffoldBackgroundColor: const Color(0xFFF3F6FA),
//       cardColor: Colors.white,
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       snackBarTheme: base.snackBarTheme.copyWith(
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       inputDecorationTheme: base.inputDecorationTheme.copyWith(
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   /// Dark Theme
//   static ThemeData get darkTheme {
//     final base = ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       colorScheme: ColorScheme.fromSeed(
//         seedColor: _seedColor,
//         brightness: Brightness.dark,
//       ),
//     );

//     return base.copyWith(
//       scaffoldBackgroundColor: const Color(0xFF050B10),
//       cardColor: const Color(0xFF111827),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       snackBarTheme: base.snackBarTheme.copyWith(
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       inputDecorationTheme: base.inputDecorationTheme.copyWith(
//         filled: true,
//         fillColor: const Color(0xFF020617),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }






















import 'package:flutter/material.dart';

class AppTheme {
  /// LOGO PRIMARY COLOR (Royal Blue)
  static const Color _seedColor = Color(0xFF0A1EA8);

  /// Light Theme
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF4F7FF),
      cardColor: Colors.white,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Color(0xFF0A1EA8),
      ),

      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E40AF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),

      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A1EA8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: Brightness.dark,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF020617),
      cardColor: const Color(0xFF0B1220),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),

      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: const Color(0xFF1E40AF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),

      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: const Color(0xFF020617),
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
