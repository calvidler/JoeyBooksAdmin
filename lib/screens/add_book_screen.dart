import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AddBookScreen extends StatefulWidget {
  static String id = "add_book_screen";

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: animation.value,
      backgroundColor: Colors.white,
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
              child: Text("Add Book"),
            ),
          ],
        ),
      ),
    );
  }
}
