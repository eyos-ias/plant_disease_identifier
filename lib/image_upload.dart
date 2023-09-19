import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'plant-api.dart';

class CloudinaryExample extends StatefulWidget {
  const CloudinaryExample({super.key});

  @override
  State<CloudinaryExample> createState() => _CloudinaryExampleState();
}

File? pickedImage;
String? CloudImageUrl;
bool loading = false;
String cloudName = "dw5j5q9jz";
bool notUploaded = true;

class _CloudinaryExampleState extends State<CloudinaryExample> {
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
      await _uploadImage(pickedImage!);
    }
  }

  Future<void> _uploadImage(File image) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'lmqyq1fs'
      ..files.add(await http.MultipartFile.fromPath('file', image!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      setState(() {
        CloudImageUrl = jsonMap['url'];
        notUploaded = false;
      });
      print(CloudImageUrl);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloudinary Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notUploaded
            ? const Center(child: Text('Uploading..'))
            : Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: pickedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                pickedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Text(
                                'No image selected.',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await pickImage(ImageSource.gallery);
                    },
                    child: const Text('Upload from gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await pickImage(ImageSource.camera);
                    },
                    child: const Text('Upload from Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await PlantApi().identifyPlant(CloudImageUrl!);
                    },
                    child: const Text('Test the api'),
                  )
                ],
              ),
      ),
    );
  }
}
