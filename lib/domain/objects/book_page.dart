import 'dart:typed_data';

import 'package:flutter/material.dart';

class BookPage {
  String pageNumber;
  String text;
  String mp3Url;
  //in ms
  double startTime;
  double endTime;
  BookPage({
    this.pageNumber,
    this.text,
    this.startTime,
    this.endTime,
    this.mp3Url,
  });
}
