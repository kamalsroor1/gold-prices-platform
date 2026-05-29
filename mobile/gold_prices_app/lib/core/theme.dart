import 'package:flutter/material.dart';

class AppTheme {
  static const Color amoledBlack = Color(0xFF090909); // أسود نقي ومريح جداً للعين
  static const Color darkCard = Color(0xFF161616);    // رمادي صلب للبطاقات
  static const Color primaryTeal = Color(0xFF00BFA5);  // الفيروزي المميز المستوحى من صورتك
  static const Color accentGold = Color(0xFFFFD700);   // لون ذهبي خفيف للتلميحات
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color borderGrey = Color(0xFF222222);   // إطار خفيف جداً حول البطاقات

  static ThemeData get amoledDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: amoledBlack,
      primaryColor: primaryTeal,
      colorScheme: const ColorScheme.dark(
        primary: primaryTeal,
        secondary: accentGold,
        surface: darkCard,
        background: amoledBlack,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: amoledBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textWhite),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderGrey, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        labelStyle: const TextStyle(color: textGrey),
        hintStyle: const TextStyle(color: textGrey),
        prefixIconColor: primaryTeal,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkCard,
        selectedItemColor: primaryTeal,
        unselectedItemColor: textGrey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
