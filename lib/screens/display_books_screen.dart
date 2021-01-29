import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:joey_books_admin_app/objects/book.dart';
import 'package:joey_books_admin_app/screens/add_book_screen.dart';
import 'package:joey_books_admin_app/components/alert_dialog.dart';

class DisplayBooks extends StatefulWidget {
  static String id = "display_screen";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  _DisplayBooksState createState() => _DisplayBooksState();
}

class _DisplayBooksState extends State<DisplayBooks> {
  List<Book> _books = [];

  Future<void> getBookRecord() async {
    CollectionReference db_books =
        FirebaseFirestore.instance.collection('Books');
    await db_books.get().then(
      (value) {
        if (value.docs.length > 0) {
          for (int i = 0; i < value.docs.length; i++) {
            Book book = Book(
              title: value.docs[i]['title'],
              authour: value.docs[i]['authour'],
              blurb: value.docs[i]['blurb'],
              age: value.docs[i]['age'],
              tags: value.docs[i]['tags'],
            );
            setState(() {
              _books.add(book);
            });
          }
          //return (value.docs);
        } else {
          print("No books retrieved");
          //return null;
        }
      },
    );
  }

  Future<void> deleteBookRecord(String title, String authour) async {
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
    }).catchError((error) => print("Failed to delete book: $error"));
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
                      // mainAxisAlignment: MainAxisAlignment.center,
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
                          child: FlatButton(
                            child: Text("Delete"),
                            onPressed: () {
                              // showAlertDialog(context);
                              deleteBookRecord(
                                  _books[i].title, _books[i].authour);
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
