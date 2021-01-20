import 'dart:html';

import 'package:flutter/material.dart';
import 'package:joey_books_admin_app/objects/book.dart';
import 'package:joey_books_admin_app/objects/book_page.dart';

class AddBook extends StatefulWidget {
  FunctionStringCallback title;
  Function authour;
  Function blurb;
  Function age;
  Function category;
  Function book;

  AddBook(
      {this.title,
      this.blurb,
      this.authour,
      this.category,
      this.age,
      this.book});
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  List<BookPage> bookPages;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("TITLE: "),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.title(value);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("AUTHOUR: "),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.authour(value);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("BLURB: "),
              Flexible(
                child: Container(
                  margin: EdgeInsets.all(12),
                  height: 5 * 24.0,
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    onChanged: (value) {
                      widget.blurb(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("AGE: "),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.age(int);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text("CATEGORY: "),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    widget.category(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
