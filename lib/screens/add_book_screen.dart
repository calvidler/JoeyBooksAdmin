import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:joey_books_admin_app/domain/objects/book_page.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/components/add_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddBookScreen extends StatefulWidget {
  static String id = "add_book_screen";
//  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: animation.value,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.send,
        ),
        onPressed: () async {},
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
                      Navigator.pop(context);
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
//                title: title,
//                authour: authour,
//                blurb: blurb,
//                age: age,
//                tags: tags,
//                book: book,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
