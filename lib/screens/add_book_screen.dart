import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:joey_books_admin_app/objects/book_page.dart';
import 'package:joey_books_admin_app/objects/book.dart';
import 'package:joey_books_admin_app/components/add_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddBookScreen extends StatefulWidget {
  static String id = "add_book_screen";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  String _title;
  title(String value) => setState(() => _title = value);
  String _authour;
  authour(String value) => setState(() => _authour = value);
  String _blurb;
  blurb(String value) => setState(() => _blurb = value);
  String _age;
  age(String value) => setState(() => _age = value);
  String _category;
  category(String value) => setState(() => _category = value);
  Book _book;
  book(Book value) => setState(() => _book = value);

  Future<void> createBookRecord() async {
    CollectionReference books = FirebaseFirestore.instance.collection('Books');
    await books
        .add({
          "title": _title,
          'authour': _authour,
          'blurb': _blurb,
          'age': _age,
          'category': _category,
          'pages': {
            '1': "Hello word",
            "2": "Goodbye World",
          }
        })
        .then((value) => print("Book Added"))
        .catchError((error) => print("Failed to add book: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: animation.value,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send,
        ),
        onPressed: () async {
          print("Send! $_title");
//          await createBookRecord();
          createBookRecord();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 20.0, height: 100.0),
                  RotateAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: ["READ", "LOVE", "JOEY"],
                    textStyle: TextStyle(
                        fontSize: 40.0,
                        fontFamily: "Horizon",
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.start,
                    isRepeatingAnimation: false,
                  ),
                  SizedBox(width: 10.0, height: 100.0),
                  Text(
                    "Books",
                    style: TextStyle(fontSize: 43.0),
                  ),
                ],
              ),
            ),
            Center(
              child: AddBook(
                title: title,
                authour: authour,
                blurb: blurb,
                age: age,
                category: category,
                book: book,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
