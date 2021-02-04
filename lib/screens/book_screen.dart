import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:joey_books_admin_app/components/display_pages.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/components/file_picker.dart';
import 'package:joey_books_admin_app/domain/book_brain.dart' as book_brain;
import 'package:flutter/services.dart' show rootBundle;
import 'package:joey_books_admin_app/domain/csv_loader.dart' as loader;
import 'package:joey_books_admin_app/screens/display_books_screen.dart';
import 'package:flutter_web_scrollbar/flutter_web_scrollbar.dart';

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
  Book pagesBook;

  void uploadImageFn(Uint8List uploadedImage) {
    setState(() {
      this.uploadedImage = uploadedImage;
    });
  }

  Future<void> uploadMp3(Uint8List mp3) async {
    Book newBook = await book_brain.BookBrain()
        .uploadBookMp3(mp3, widget.book, "book-audio.mp3");
    setState(() {
      widget.book = newBook;
    });
  }

  void uploadPages(Uint8List pages) {
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
    });
  }

  void getBookPages() async {
    Book pBook = await book_brain.BookBrain().getBookPages(widget.book);
    setState(() {
      pagesBook = pBook;
    });
  }

  ScrollController _controller;

  void scrollCallBack(DragUpdateDetails dragUpdate) {
    setState(() {
      // Note: 3.5 represents the theoretical height of all my scrollable content. This number will vary for you.
      _controller.position.moveTo(dragUpdate.globalPosition.dy * 3.5);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null)
      widget.book = arguments['book'];
    else
      Navigator.pushNamedAndRemoveUntil(
          context, DisplayBooks.id, (route) => false);
    if (counter == 0) {
      getBookImage();
      getBookPages();
      counter++;
    }
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("Save"),
          onPressed: () async {
            await book_brain.BookBrain().uploadImage(
                uploadedImage, widget.book, "cover-image.jpg", "coverImageURL");
          },
        ),
        body: Stack(
          children: [
            Container(
              child: SingleChildScrollView(
                controller: _controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, DisplayBooks.id, (route) => false);
                        },
                        child: Text("Home"),
                      ),
                    ),
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
                      child: imageUrl == null && uploadedImage == null
                          ? FilePicker(
                              use: "image",
                              uploadFileFn: uploadImageFn,
                              child: SizedBox(
                                height: 250,
                                width: 250,
                                child: Container(
                                  color: Colors.grey.shade700,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add),
                                        Text("Image"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              child: imageUrl != null
                                  ? Container() //Image.network(imageUrl)
                                  : Image.memory(uploadedImage),
                              height: 350,
                              width: 350,
                            ),
                    ),
                    imageUrl != null ? Text(imageUrl) : Text("No Image"),
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
                        Center(child: Text("Upload Book Pages (.xlsx): ")),
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
                        Center(
                          child: widget.book.bookMp3Url == null
                              ? Text("Upload mp3 : ")
                              : Text("Upload new MP3: "),
                        ),
                        Center(
                          child: FilePicker(
                            uploadFileFn: uploadMp3,
                            use: "mp3",
                            child: Text("Upload"),
                          ),
                        ),
                      ],
                    ),
                    pagesBook == null
                        ? Text("No Pages")
                        : DisplayPages(book: pagesBook),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
