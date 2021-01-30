import 'package:flutter/material.dart';
import 'package:joey_books_admin_app/domain/objects/book.dart';
import 'package:joey_books_admin_app/domain/book_brain.dart' as book_brain;

class DisplayPages extends StatefulWidget {
  Book book;
  DisplayPages({@required this.book});
  @override
  _DisplayPagesState createState() => _DisplayPagesState();
}

class _DisplayPagesState extends State<DisplayPages> {
  void getPages() {
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
              Text("Pages Number"),
              Expanded(child: Text("Text")),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount:
                  widget.book.pages != null ? widget.book.pages.length : 0,
              itemBuilder: (context, i) {
                return Container(
                  height: 30,
                  child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(widget.book.pages[i].pageNumber),
                      Expanded(
                        child: Text(widget.book.pages[i].text),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
