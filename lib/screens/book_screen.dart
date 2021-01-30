import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:joey_books_admin_app/components/display_pages.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/components/file_picker.dart';
import 'package:joey_books_admin_app/domain/book_brain.dart' as book_brain;
import 'package:flutter/services.dart' show rootBundle;
import 'package:joey_books_admin_app/domain/csv_loader.dart' as loader;

class BookScreen extends StatefulWidget {
  static String id = "book_screen";

  Book book;
  BookScreen({this.book});
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  String imageUrl;
  Uint8List uploadedImage;
  Image imgFromUrl;

  void uploadImageFn(Uint8List uploadedImage) {
    setState(() {
      this.uploadedImage = uploadedImage;
    });
  }

  void uploadMp3(Uint8List mp3) {
    book_brain.BookBrain()
        .uploadMp3(mp3, widget.book, "book-audio.mp3", "bookAudio");
  }

  void uploadPages(Uint8List pages) {
    print("pages");
    setState(() {
      widget.book =
          loader.CsvLoader().excelAddPages(file: pages, book: widget.book);
    });
    book_brain.BookBrain().uploadPages(widget.book);
  }

  getBookImage() async {
    String imageURL = await book_brain.BookBrain()
        .getBookImageURL(widget.book, "coverImageURL");
    setState(() {
      imageUrl = imageURL;
//      imgFromUrl = Image.network(imageURL);
      print(imgFromUrl);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null)
      widget.book = arguments['book'];
    else
      widget.book = Book(
          title: "Peter Rabbit",
          authour: "Beatrix Potter",
          blurb: " ",
          age: " ",
          tags: " ");
    if (counter == 0) {
      getBookImage();
      counter++;
    }
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("Save"),
          onPressed: () async {
            await book_brain.BookBrain().uploadImage(
                uploadedImage, widget.book, "cover-image.jpg", "coverImageURL");
            print("save!");
          },
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  "${widget.book.title}",
                  textAlign: TextAlign.center,
                  textScaleFactor: 3.0,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  child: // imageUrl == null && uploadedImage == null ?
                      FilePicker(
                use: "image",
                uploadFileFn: uploadImageFn,
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Container(
                    color: Colors.grey.shade700,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text("Image"),
                        ],
                      ),
                    ),
                  ),
                ),
              )
//                    : SizedBox(
//                        child: imageUrl != null
//                            ? Image.network(imageUrl)
//                            : Image.memory(uploadedImage),
//                        height: 350,
//                        width: 350,
//                      ),
                  ),
              imageUrl != null ? Text(imageUrl) : Container(),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text("By ${widget.book.authour}"),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Upload Book Pages: ")),
                  Center(
                    child: FilePicker(
                      uploadFileFn: uploadPages,
                      use: "excel",
                      child: Text("Upload"),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text("Upload mp3 (.xlsx): ")),
                  Center(
                    child: FilePicker(
                      uploadFileFn: uploadMp3,
                      use: "mp3",
                      child: Text("Upload"),
                    ),
                  ),
                ],
              ),
//              DisplayPages(book: widget.book),
            ],
          ),
        ),
      ),
    );
  }
}
