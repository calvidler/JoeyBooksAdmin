import 'book_page.dart';

class Book {
  String title;
  String authour;
  String blurb;
  String age;
  String tags;

  List<BookPage> pages = [];

  Book({
    this.title,
    this.authour,
    this.blurb,
    this.age,
    this.tags,
  });

  add_page(BookPage page) {
    pages.add(page);
  }
}
