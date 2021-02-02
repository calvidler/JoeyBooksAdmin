import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:joey_books_admin_app/domain/objects/book_page.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

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

Future<String> uploadMp3File(Uint8List mp3, Book book, String fileName) async {
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('images')
      .child("books")
      .child("${book.title}")
      .child("${book.authour}")
      .child(fileName);
  ref.putData(mp3);

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

Future<String> getBookImageURL(String bookID, String fieldName) async {
  String url = "No image";
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

Future<void> uploadBookPages(Book book, Map<String, String> map) async {
  String id = await getBookID(book.title, book.authour);

  await FirebaseFirestore.instance
      .collection('Books')
      .doc(id)
      .update({'pages': map})
      .then((value) => print("Successfully uploaded pages!"))
      .catchError((error) => print("error uploading pages : $error"));
}

Future<Book> getBookPages(Book book) async {
  String id = await getBookID(book.title, book.authour);
  await FirebaseFirestore.instance
      .collection('Books')
      .doc(id)
      .get()
      .then((value) {
    Map<String, String> map = value.get("pages");
    map.forEach((k, v) => book.add_page(BookPage(pageNumber: k, text: v)));
    print("Successfully retrieved pages!");
  }).catchError((error) => print("error retrieving pages : $error"));

  return book;
}
