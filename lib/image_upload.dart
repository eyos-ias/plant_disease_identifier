import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'plant-api.dart';
import 'diagonosis_box.dart';

class DiseaseIdentifier extends StatefulWidget {
  const DiseaseIdentifier({super.key});

  @override
  State<DiseaseIdentifier> createState() => _DiseaseIdentifierState();
}

File? pickedImage;
String? CloudImageUrl;
bool uploadingImage = false;
String cloudName = "dw5j5q9jz";
bool testable = false;
Map<String, dynamic> diagnosisData = {};
bool diagnosisAvailable = false;
bool diagnosingImage = false;

class _DiseaseIdentifierState extends State<DiseaseIdentifier> {
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
    setState(() {
      uploadingImage = true;
      testable = false;
    });

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
        uploadingImage = false;
        testable = true;
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
      body: SingleChildScrollView(
        child: uploadingImage
            ? const Center(
                child: Text("Uploading Image...",
                    style: TextStyle(fontWeight: FontWeight.bold)))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
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
                  uploadingImage
                      ? const Center(
                          child: Text("Uploading Image...",
                              style: TextStyle(fontWeight: FontWeight.bold)))
                      : Column(
                          children: [
                            testable
                                ? ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        diagnosingImage = true;
                                      });
                                      Map<String, dynamic> data =
                                          await PlantApi()
                                              .identifyPlant(CloudImageUrl!);

                                      setState(() {
                                        diagnosingImage = false;
                                        diagnosisData = data;
                                        diagnosisAvailable = true;
                                      });
                                    },
                                    child: const Text('Diagnose the plant'),
                                  )
                                : const SizedBox(),
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
                          ],
                        ),
                  diagnosisAvailable
                      ? DiagnosisBox(data: diagnosisData)
                      : diagnosingImage
                          ? const Center(
                              child: Text('Diagnosing plant'),
                            )
                          : const SizedBox()
                ],
              ),
      ),
    );
  }
}
