import 'book_page.dart';

class Book {
  String title;
  String authour;
  String blurb;
  String age;
  String tags;
  String bookMp3Url;

  List<BookPage> pages = [];

  Book({
    this.title,
    this.authour,
    this.blurb,
    this.age,
    this.tags,
    this.bookMp3Url,
  });

  add_page(BookPage page) {
    pages.add(page);
  }
}
