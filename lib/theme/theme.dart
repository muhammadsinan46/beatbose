import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    final colorScheme =
        isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light();
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: isDarkTheme
            ? Colors.tealAccent.shade400
            : const Color.fromARGB(255, 36, 34, 167),
      ),
      expansionTileTheme: ExpansionTileThemeData(
          iconColor: isDarkTheme ? Colors.white : Colors.black,
          textColor: isDarkTheme ? Colors.white : Colors.black),
sliderTheme: SliderThemeData(activeTrackColor: isDarkTheme
            ? Colors.tealAccent.shade400
            : const Color.fromARGB(255, 36, 34, 167),),
      textTheme: isDarkTheme
          ? GoogleFonts.montserratTextTheme(
              const TextTheme(bodyLarge: TextStyle(color: Colors.black)))
          : GoogleFonts.montserratTextTheme(
              const TextTheme(bodyLarge: TextStyle(color: Colors.white))),
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      shadowColor: isDarkTheme
          ? const Color.fromARGB(255, 177, 181, 180)
          : Color.fromARGB(255, 110, 110, 116),
      colorScheme: colorScheme,
      iconTheme: IconThemeData(
        color: isDarkTheme
            ? Colors.tealAccent.shade400
            : const Color.fromARGB(255, 36, 34, 167),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll( isDarkTheme
          ? const Color.fromARGB(255, 177, 181, 180)
          : Color.fromARGB(255, 110, 110, 116),))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: isDarkTheme
            ? Colors.tealAccent.shade400
            : const Color.fromARGB(255, 36, 34, 167),
      )),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDarkTheme
              ? const Color.fromARGB(255, 192, 195, 194)
              : Color.fromARGB(255, 82, 82, 82),
        ),
        focusColor: isDarkTheme
            ? Colors.tealAccent.shade400
            : const Color.fromARGB(255, 36, 34, 167),
      ),
      indicatorColor: isDarkTheme
          ? Colors.tealAccent.shade400
          : const Color.fromARGB(255, 36, 34, 167),

      hintColor: isDarkTheme
          ? const Color(0xff280C0B)
          : Color.fromARGB(255, 206, 226, 238),

      highlightColor: isDarkTheme
          ? const Color(0xff372901)
          : Color.fromARGB(255, 146, 201, 252),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),

      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),

      disabledColor: Colors.grey,
      // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,

      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme
            ? Colors.tealAccent.shade400
            : const Color.fromARGB(255, 36, 34, 167),
        elevation: 0.0,
      ),
    );
  }
}
