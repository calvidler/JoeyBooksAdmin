import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:html';

class FilePicker extends StatefulWidget {
  Function uploadFileFn;
  String use;
  final Widget child;

  FilePicker({this.uploadFileFn, this.use, @required this.child});
  @override
  _FilePickerState createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  Uint8List uploadedXlsx;
  Uint8List uploadedImage;
  String option1Text;
  _startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            if (widget.use == "excel") {
//              uploadedXlsx = Base64Decoder()
//                  .convert(reader.result.toString().split(",").last);
//              print(utf8.decode(uploadedXlsx));
              uploadedXlsx = reader.result;

              widget.uploadFileFn(uploadedXlsx);
            }
            if (widget.use == "mp3") {
//              uploadedXlsx = Base64Decoder()
//                  .convert(reader.result.toString().split(",").last);
//              print(utf8.decode(uploadedXlsx));
              uploadedXlsx = reader.result;

              widget.uploadFileFn(uploadedXlsx);
            }
            if (widget.use == "image") {
              uploadedImage = reader.result;
              widget.uploadFileFn(uploadedImage);
            }
          });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            option1Text = "Some Error occured while reading the file";
          });
        });

        reader.readAsArrayBuffer(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: _startFilePicker, child: widget.child);
  }
}
