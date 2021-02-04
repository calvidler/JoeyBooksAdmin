import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:joey_books_admin_app/components/display_pages.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/screens/add_book_screen.dart';
import 'package:joey_books_admin_app/components/alert_dialog.dart';
import 'book_screen.dart';

class DisplayBooks extends StatefulWidget {
  static String id = "display_screen";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  _DisplayBooksState createState() => _DisplayBooksState();
}

class _DisplayBooksState extends State<DisplayBooks> {
  List<Book> _books = [];
  List<bool> _warnings = [];

  Future<void> getBookRecord() async {
    CollectionReference db_books =
        FirebaseFirestore.instance.collection('Books');
    await db_books.get().then(
      (value) {
        if (value.docs.length > 0) {
          for (int i = 0; i < value.docs.length; i++) {
            Book book = Book(
              title: value.docs[i].get('title'),
              authour: value.docs[i].get('authour'),
              blurb: value.docs[i].get('blurb'),
              age: value.docs[i].get('age'),
              tags: value.docs[i].get('tags'),
            );
            setState(() {
              _books.add(book);
            });
            if (value.docs[i].data().containsKey("pages") == false) {
              _warnings.add(true);
            } else {
              _warnings.add(false);
            }
          }
          //return (value.docs);
        } else {
          print("No books retrieved");
          //return null;
        }
      },
    ).catchError((error) => print("Failed to get display data: $error"));
  }

  Future<void> deleteBookRecord(
      String title, String authour, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("Books")
        .where("title", isEqualTo: title)
        .where('authour', isEqualTo: authour)
        .get()
        .then((value) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance
                .collection("Books")
                .doc(element.id)
                .delete()
                .then((value) {
              print("Success!");
            }).catchError((error) => print("Failed to delete book: $error"));
          });
        })
        .then((value) => Navigator.pushNamedAndRemoveUntil(
            context, DisplayBooks.id, (route) => false))
        .catchError((error) => print("Failed to delete book: $error"));
  }

  @override
  void initState() {
    super.initState();
    getBookRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddBookScreen.id);
        },
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: Text("Title")),
                Expanded(child: Text("Authour")),
                Expanded(child: Text("Blurb")),
                Expanded(child: Text("Age")),
                Expanded(child: Text("Tags")),
                Expanded(child: Text("Warning No pages!")),
                Expanded(child: Text("")),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: 5.0,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _books.length,
                itemBuilder: (context, i) {
                  return Container(
                    height: 30,
                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Text(_books[i].title),
                        ),
                        Expanded(
                          child: Text(_books[i].authour),
                        ),
                        Expanded(
                          child: Text(_books[i].blurb),
                        ),
                        Expanded(
                          child: Text(_books[i].age.toString()),
                        ),
                        Expanded(
                          child: Text(_books[i].tags),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              primary: _warnings[i] ? Colors.red : Colors.green,
                            ),
                            onPressed: () {
                              // showAlertDialog(context);
                              Navigator.pushNamed(context, BookScreen.id,
                                  arguments: {'book': _books[i]});
                            },
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: Text("Delete"),
                            onPressed: () {
                              // showAlertDialog(context);
                              deleteBookRecord(
                                  _books[i].title, _books[i].authour, context);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
