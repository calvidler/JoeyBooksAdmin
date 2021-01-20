import 'package:joey_books_admin_app/objects/book_page.dart';

class Book {
  String title;
  String author;
  String blurb;
  int age;
  String coverImage;
  String category;

  Book(
      {this.title,
      this.author,
      this.blurb,
      this.age,
      this.coverImage,
      this.category});
}
