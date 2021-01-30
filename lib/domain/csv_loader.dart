import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/domain/objects/book_page.dart';
import 'package:joey_books_admin_app/domain/objects/book_page.dart';
import 'package:excel/excel.dart';

class CsvLoader {
  List<Book> excelToBooks(Uint8List file) {
    List<Book> books = [];
    var bytes = file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        if (row[0].toString().toLowerCase() != "title") {
          Book book = Book(
              title: row[0],
              authour: row[1],
              blurb: row[2],
              age: row[3].toString(),
              tags: row[4]);
          books.add(book);
        }
      }
    }
    return books;
  }

  Book excelAddPages({Uint8List file, Book book}) {
    var bytes = file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        if (row[0].toString().toLowerCase() != "title" &&
            row[0].toString().toLowerCase() != "authour") {
          print(row[1]);
          book.add_page(BookPage(pageNumber: row[0].toString(), text: row[1]));
        }
      }
    }
    return book;
  }
}
