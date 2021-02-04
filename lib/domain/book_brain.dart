import 'dart:typed_data';
import 'dart:ui';

import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/dataSource/book_db.dart' as db;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'objects/book_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class BookBrain {
  Future<Book> getBook(String authour, String title) {}
  Future<bool> isExisting(Book book) async {
    return await db.isBookExist(book);
  }

  Future<void> uploadBook(Book book) async {
    await db.uploadBookToDB(book);
  }

  Future<void> uploadBooks(List<Book> books) async {
    for (Book book in books) {
      bool add = await db.isBookExist(book);
      if (add) {
        db.updateBook(book);
      }
      uploadBook(book);
    }
  }

  Future<void> uploadImage(
      Uint8List image, Book book, String fileName, String fieldName) async {
    String imageURL = await db.uploadImageFile(image, book, fileName);
    await db.uploadBookImage(imageURL, book, fieldName);
  }

  Future<Book> uploadBookMp3(Uint8List mp3, Book book, String fileName) async {
    String url = await db.uploadBookMp3File(mp3, book, fileName);
    book.bookMp3Url = url;

    book = await createPageMp3(book, mp3);
    return book;
  }

  Future<Book> uploadPageMp3(
      Uint8List mp3, Book book, String fileName, int pageIndex) async {
    String url = await db.uploadPagesMp3File(mp3, book, fileName);
    book.pages[pageIndex].mp3Url = url;

    await uploadPages(book);
    return book;
  }

  Future<void> uploadPages(Book book) async {
    Map<String, Map<String, dynamic>> map = {};

    for (BookPage page in book.pages) {
      Map<String, dynamic> pageMap = {};
      pageMap['text'] = page.text;
      pageMap['mp3Url'] = page.mp3Url;
      pageMap['startTime'] = page.startTime;
      pageMap['endTime'] = page.endTime;
      map[page.pageNumber] = pageMap;
    }
    db.uploadBookPages(book, map);
  }

  Future<String> getBookID(Book book) async {
    return await db.getBookID(book.title, book.authour);
  }

  Future<String> getBookImageURL(Book book, String fieldName) async {
    String id = await getBookID(book);
    return await db.getBookImageURL(id, fieldName);
  }

  Future<Book> getBookPages(Book book) async {
    book = await db.getBookPages(book);

    return book;
  }

  int getPageIndex(String pageNumber, Book book) {
    if (book.pages.length == 0) return -1;
    for (int i = 0; i < book.pages.length; i++) {
      if (book.pages[i].pageNumber == pageNumber) return i;
    }
    return -1;
  }

  Future<Book> createPageMp3(Book book, Uint8List mp3) async {
    if (book.pages.length == 0 || book.bookMp3Url == null || mp3 == null)
      return book;
    for (int i = 0; i < book.pages.length; i++) {
      BookPage page = book.pages[i];
      int start = (page.startTime * 1000 * 24).round();
      int end = (page.endTime * 1000 * 24).round();
      Uint8List pageMp3 = Uint8List.sublistView(mp3, start, end);
      book =
          await uploadPageMp3(pageMp3, book, "page-${page.pageNumber}.mp3", i);
    }
    return book;
  }
}
