import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/domain/book_brain.dart' as book_brain;
import 'file_picker.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class DisplayPages extends StatefulWidget {
  Book book;
  DisplayPages({@required this.book});
  @override
  _DisplayPagesState createState() => _DisplayPagesState();
}

class _DisplayPagesState extends State<DisplayPages> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  void playUrlAudio(String url) async {
    try {
      await this.assetsAudioPlayer.open(
            Audio.network(url),
          );
    } catch (t) {
      //mp3 unreachable
    }
  }

  void uploadPageMp3(Uint8List mp3, String pageIndex) async {
    Book tempBook = await book_brain.BookBrain()
        .uploadBookMp3(mp3, widget.book, "page-${pageIndex}-audio.mp3");
    setState(() {
      widget.book = tempBook;
    });
  }

  void getPages() async {
    if (widget.book.pages == null) {
      setState(() async {
        widget.book = await book_brain.BookBrain().getBookPages(widget.book);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPages();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: SizedBox(
                  width: 200,
                  child: Text("Page Number"),
                ),
              ),
              Expanded(child: Text("Text")),
              Container(
                child: SizedBox(
                  width: 200,
                  child: Text("Page Audio"),
                ),
              ),
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
          Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.book.pages.length,
                itemBuilder: (context, i) {
                  return Container(
                    height: 30,
                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: SizedBox(
                            width: 200,
                            child: Text(widget.book.pages[i].pageNumber),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.book.pages[i].text),
                        ),
                        Container(
                          child: SizedBox(
                            width: 200,
                            child: widget.book.pages[i].mp3Url == null
                                ? Text("Upload Book audio")
                                : ElevatedButton(
                                    onPressed: () {
                                      playUrlAudio(widget.book.pages[i].mp3Url);
                                    },
                                    child: Icon(Icons.play_arrow),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
