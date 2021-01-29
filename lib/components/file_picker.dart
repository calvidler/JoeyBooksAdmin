import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:html';

class FilePicker extends StatefulWidget {
  Function uploadFileFn;

  FilePicker({this.uploadFileFn});
  @override
  _FilePickerState createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  Uint8List uploadedCsv;
  String option1Text;

  _startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURLs
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedCsv = Base64Decoder()
                .convert(reader.result.toString().split(",").last);
            // print(utf8.decode(uploadedCsv));
            widget.uploadFileFn(uploadedCsv);
          });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            option1Text = "Some Error occured while reading the file";
          });
        });

        reader.readAsDataUrl(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(onPressed: _startFilePicker, child: Text("Upload"));
  }
}
