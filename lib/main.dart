import "package:firebase_core/firebase_core.dart";
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";
import "login.dart";
import "navi.dart";


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('sign_or_login') ?? false;
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.red[600],
          scaffoldBackgroundColor: Colors.red[100],

          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red[500],
            titleTextStyle: TextStyle(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
          ),

          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            titleMedium: TextStyle(color: Colors.black87),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red), // Border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.redAccent), // Focused border color
            ),
            labelStyle: const TextStyle(color: Colors.red), // Label color
            hintStyle: const TextStyle(color: Colors.grey), // Hint text color
          ),
        ),
        home: isLoggedIn ? AppNavigator() : LoginPage(),
      )
  );
}




