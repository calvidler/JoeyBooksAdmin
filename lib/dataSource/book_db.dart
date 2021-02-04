import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joey_books_admin_app/domain/book_brain.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:joey_books_admin_app/domain/objects/book_page.dart';
import 'package:joey_books_admin_app/screens/book_screen.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

Future<Book> getBook(String authour, String title) async {
  String id = await getBookID(title, authour);
  Book book = Book(authour: authour, title: title);
  await FirebaseFirestore.instance
      .collection('Books')
      .doc(id)
      .get()
      .then((value) {
    var age = value.get("age");
    var blurb = value.get('blurb');
    var bookMp3Url = value.get('bookMp3Url');
    var tags = value.get('tags');
    book = Book(
        authour: authour,
        title: title,
        tags: tags,
        age: age,
        blurb: blurb,
        bookMp3Url: bookMp3Url);
    print("Successfully retrieved pages!");
  }).catchError((error) => print("error retrieving pages : $error"));
  book = await BookBrain().getBookPages(book);
  return book;
}

Future<void> uploadBookToDB(Book book) async {
  CollectionReference dbBooks = FirebaseFirestore.instance.collection('Books');
  await dbBooks.add({
    "title": book.title,
    'authour': book.authour,
    'blurb': book.blurb,
    'age': book.age,
    'tags': book.tags,
  }).then((value) {
    print("Book ${book.title} Added");
  }).catchError((error) => print("Failed to add book ${book.title}: $error"));
  BookBrain().uploadPages(book);
}

Future<void> updateBook(Book book) async {
  String id = await getBookID(book.title, book.authour);

  await FirebaseFirestore.instance
      .collection('Books')
      .doc(id)
      .update({
        "title": book.title,
        'authour': book.authour,
        'blurb': book.blurb,
        'age': book.age,
        'tags': book.tags,
        'bookMp3Url': book.bookMp3Url,
      })
      .then((value) => print("Successfully updated book!"))
      .catchError((error) => print("error updating book : $error"));
}

Future<String> uploadImageFile(
    Uint8List _image, Book book, String fileName) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child("books")
      .child("${book.title}")
      .child("${book.authour}")
      .child(fileName);
  ref.putData(_image);

  //getting url to reference from db collection
  String returnURL = await ref.getDownloadURL();
  return returnURL;
}

Future<String> uploadBookMp3File(
    Uint8List mp3, Book book, String fileName) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('audio')
      .child("books")
      .child("${book.title}")
      .child("${book.authour}")
      .child(fileName);
  await ref
      .putData(mp3)
      .then((value) => print("successfully uploaded mp3"))
      .catchError((error) => print("Failed to mp3 ${fileName}: $error"));

  //getting url to reference from db collection
  String returnURL = await ref.getDownloadURL();
  return returnURL;
}

Future<String> uploadPagesMp3File(
    Uint8List mp3, Book book, String fileName) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('audio')
      .child("books")
      .child("${book.title}")
      .child("${book.authour}")
      .child("pages")
      .child(fileName);
  await ref
      .putData(mp3)
      .then((value) => print("successfully uploaded mp3"))
      .catchError((error) => print("Failed to mp3 ${fileName}: $error"));

  //getting url to reference from db collection
  String returnURL = await ref.getDownloadURL();
  return returnURL;
}

Future<void> uploadBookImage(String imageURL, Book book, String field) async {
  await FirebaseFirestore.instance
      .collection("Books")
      .where("title", isEqualTo: book.title)
      .where('authour', isEqualTo: book.authour)
      .limit(1)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("Books")
          .doc(element.id)
          .update({field: imageURL})
          .then((value) => print("Updated Book!"))
          .catchError((error) => print("Failed to update book: $error"));
    });
  }).catchError((error) => print("Failed to update book: $error"));
//    ref.update({
//      "images": FieldValue.arrayUnion([imageURL])
//    });
}

Future<String> getBookID(String bookTitle, String authour) async {
  String id;
  await FirebaseFirestore.instance
      .collection("Books")
      .where("title", isEqualTo: bookTitle)
      .where('authour', isEqualTo: authour)
      .limit(1)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      id = element.id;
    });
  }).catchError((error) => print("Failed to get book: $error"));
  return id;
}

Future<bool> isBookExist(Book book) async {
  String id = await getBookID(book.title, book.authour);
  if (id == null) print("Added book: ${book.title}");
  return id != null;
}

Future<String> getBookImageURL(String bookID, String fieldName) async {
  String url;
  await FirebaseFirestore.instance
      .collection('Books')
      .doc(bookID)
      .get()
      .then((value) {
    url = value.get(fieldName);
    print("Sucessfull retrieved image ul");
  }).catchError((error) => print("error retieving image url : $error"));
  return url;
}

Future<void> uploadBookPages(
    Book book, Map<String, Map<String, dynamic>> map) async {
  String id = await getBookID(book.title, book.authour);

  await FirebaseFirestore.instance
      .collection('Books')
      .doc(id)
      .update({'pages': map})
      .then((value) => print("Successfully updated pages!"))
      .catchError((error) => print("error updating pages : $error"));
}

T cast<T>(x) => x is T ? x : null;
Future<Book> getBookPages(Book book) async {
  String id = await getBookID(book.title, book.authour);
  await FirebaseFirestore.instance
      .collection('Books')
      .doc(id)
      .get()
      .then((value) {
    var v = value.get("pages");
    Map<String, dynamic> map = cast<Map<String, dynamic>>(v);

    map.forEach((k, v) {
      book.add_page(BookPage(
          pageNumber: k,
          text: v['text'],
          startTime: v['startTime'],
          endTime: v['endTime'],
          mp3Url: v['mp3Url']));
    });
    print("Successfully retrieved pages!");
  }).catchError((error) => print("error retrieving pages : $error"));

  return book;
}
