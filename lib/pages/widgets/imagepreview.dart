import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savehouse/values.dart';

class ImagePreview extends StatefulWidget {
  final Widget image;

  const ImagePreview(this.image, {Key key}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black.withOpacity(.8),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: widget.image,
              ),
            ),
          ),
          Positioned(
            height: 40,
            width: 40,
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                size: 25,
                color: secondaryColor,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}

void showImagePreview(context, image) {
  showDialog(
    context: context,
    builder: (BuildContext context) => ImagePreview(image),
  );
}
