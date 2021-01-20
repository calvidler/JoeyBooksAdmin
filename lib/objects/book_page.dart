import 'package:flutter/material.dart';

class BookPage {
  int pageNumber;
  String text;
  int textPosition;
  AssetImage image;
  int imagePosition;

  BookPage(
      {this.pageNumber,
      this.text,
      this.textPosition,
      this.image,
      this.imagePosition});
}
