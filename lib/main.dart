import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:disease_identifier/image_upload.dart';
import 'package:flutter/material.dart';

void main() {
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: "dw5j5q9jz");
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CloudinaryExample(),
    );
  }
}

//https://res.cloudinary.com/dw5j5q9jz/image/upload/v1695106539/test.png