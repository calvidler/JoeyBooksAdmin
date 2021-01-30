import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/domain/objects/book_page.dart';
import 'package:joey_books_admin_app/components/file_picker.dart';
import 'package:joey_books_admin_app/domain/csv_loader.dart';
import 'package:joey_books_admin_app/domain/book_brain.dart';

class AddBook extends StatefulWidget {
  FunctionStringCallback title;
  Function authour;
  Function blurb;
  Function age;
  Function tags;
  Function book;

  AddBook(
      {this.title, this.blurb, this.authour, this.tags, this.age, this.book});
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  void uploadFile(Uint8List value) {
    List<Book> books = CsvLoader().excelToBooks(value);
    BookBrain().uploadBooks(books);
    Navigator.pop(context);
  }

  List<BookPage> bookPages;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Upload Books CSV: "),
                FilePicker(
                  uploadFileFn: uploadFile,
                  use: "excel",
                  child: Text("Upload"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
