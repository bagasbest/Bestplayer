import 'package:flutter/material.dart';

import '../../widget/theme.dart';

class ImageFull extends StatefulWidget {
  final String image;

  ImageFull({
    required this.image,
  });

  @override
  State<ImageFull> createState() => _ImageFullState();
}

class _ImageFullState extends State<ImageFull> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Themes(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Media Gambar'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Image.network(widget.image,),
        ),
      ),
    );
  }
}
