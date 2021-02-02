import 'dart:typed_data';
import 'dart:ui';

import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/dataSource/book_db.dart' as db;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'objects/book_page.dart';

class BookBrain {
  Future<void> uploadBook(Book book) async {
    await db.uploadBookToDB(book);
  }

  Future<void> uploadBooks(List<Book> books) {
    for (Book book in books) {
      uploadBook(book);
    }
  }

  Future<void> uploadImage(
      Uint8List image, Book book, String fileName, String fieldName) async {
    String imageURL = await db.uploadImageFile(image, book, fileName);
    await db.uploadBookImage(imageURL, book, fieldName);
  }

  Future<void> uploadMp3(
      Uint8List mp3, Book book, String fileName, String fieldName) async {
    db.uploadMp3File(mp3, book, fileName);
  }

  Future<void> uploadPages(Book book) async {
    Map<String, String> map = {};
    for (BookPage page in book.pages) {
      map[page.pageNumber] = page.text;
    }
    db.uploadBookPages(book, map);
  }

  Future<String> getBookRecord(Book book) async {
    return await db.getBookID(book.title, book.authour);
  }

  Future<String> getBookImageURL(Book book, String fieldName) async {
    String id = await getBookRecord(book);
    return await db.getBookImageURL(id, fieldName);
  }

  Future<Book> getBookPages(Book book) async {
    return db.getBookPages(book);
  }
}
