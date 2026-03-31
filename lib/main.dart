import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'chat.dart';
import 'home.dart';
import 'login.dart';
import 'plant_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // default language

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Disease Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4F9D69),
        scaffoldBackgroundColor: const Color(0xFFF1F8F6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA9DBCA),
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFA9DBCA),
          selectedItemColor: Color(0xFF4F9D69),
          unselectedItemColor: Colors.black54,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F9D69),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      // 🌐 Localization setup
      locale: _locale, // 👈 This makes it dynamic
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // 👈 Fixed this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      

      // ✅ Pass callback to pages so they can change language
      home: LoginPage(onLocaleChange: setLocale),
      routes: {
        '/plant-selection': (context) => PlantSelectionPage(onLocaleChange: setLocale),
        '/home': (context) => HomePage(onLocaleChange: setLocale),
        '/chat': (context) => const ChatBotPage(),
        '/login': (context) => LoginPage(onLocaleChange: setLocale),
      },
    );
  }
}

