import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:joey_books_admin_app/screens/add_book_screen.dart';
import 'package:joey_books_admin_app/screens/display_books_screen.dart';
import 'package:joey_books_admin_app/screens/book_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: DisplayBooks.id,
      routes: {
        DisplayBooks.id: (context) => DisplayBooks(),
        AddBookScreen.id: (context) => AddBookScreen(),
        BookScreen.id: (context) => BookScreen(),

        //   LoginScreen.id: (context) => LoginScreen(),
        //   RegistrationScreen.id: (context) => RegistrationScreen(),
        //   ProfileScreen.id: (context) => ProfileScreen(),
        //   ReadingListScreen.id: (context) => ReadingListScreen(),
        //   BookScreen.id: (context) => BookScreen(),
        //   LibraryScreen.id: (context) => LibraryScreen(),
      },
    );
  }
}
