import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';

class CroppedImage extends StatefulWidget {
  final String imagePath; // ใช้ imagePath แทน
  const CroppedImage({super.key, required this.imagePath});

  @override
  State<CroppedImage> createState() => _CroppedImageState();
}

class _CroppedImageState extends State<CroppedImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: InteractiveViewer(
            child: Image.file( // ใช้ Image.file แทน Image
              File(widget.imagePath), // ใช้ path จากการ crop
            ),
          ),
        ),
      ),
    );
  }
}
