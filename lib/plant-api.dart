// // var headers = {
// //   'Api-Key': 'GRNTolRKPjkhh3GtVnlgaEvLIrRPsmUaH0odzDbLyyA1m2bYdJ',
// //   'Content-Type': 'application/json'
// // };
// // var request = http.Request('POST', Uri.parse('https://plant.id/api/v3/health_assessment?language=en&details=local_name,description,url,treatment,classification,common_names,cause'));
// // request.body = json.encode({
// //   "images": [
// //     "http://res.cloudinary.com/dw5j5q9jz/image/upload/v1695111983/public/udcalkrasbe9kyaucnme.jpg"
// //   ],
// //   "latitude": 49.207,
// //   "longitude": 16.608,
// //   "similar_images": true
// // });
// // request.headers.addAll(headers);

// // http.StreamedResponse response = await request.send();

// // if (response.statusCode == 200) {
// //   print(await response.stream.bytesToString());
// // }
// // else {
// //   print(response.reasonPhrase);
// // }
// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class PlantApi {
//   // void sendRequest() async {
//   //   var headers = {
//   //     'Api-Key': 'GRNTolRKPjkhh3GtVnlgaEvLIrRPsmUaH0odzDbLyyA1m2bYdJ',
//   //     'Content-Type': 'application/json'
//   //   };
//   // }

//   Future<Map<String, dynamic>> identifyPlant() async {
//     print('Identifying plant...');
//     const String apiKey = "GRNTolRKPjkhh3GtVnlgaEvLIrRPsmUaH0odzDbLyyA1m2bYdJ";
//     const String apiUrl = "https://api.plant.id/v2/health_assessment";

//     final Map<String, dynamic> params = {
//       "images": [
//         'http://res.cloudinary.com/dw5j5q9jz/image/upload/v1695111983/public/udcalkrasbe9kyaucnme.jpg'
//       ],
//       "latitude": 49.1951239,
//       "longitude": 16.6077111,
//       "datetime": 1582830233,
//       "language": "en",
//       "disease_details": [
//         "cause",
//         "common_names",
//         "classification",
//         "description",
//         "treatment",
//         "url",
//       ],
//     };

//     final Map<String, String> headers = {
//       "Content-Type": "application/json",
//       "Api-Key": apiKey,
//     };

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: jsonEncode(params),
//     );

//     if (response.statusCode == 200) {
//       print(json.decode(response.body));
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to identify plant: ${response.statusCode}');
//     }
//   }

//   // Future<String> encodeFile(String fileName) async {
//   //   // Implement your file encoding logic here.
//   //   // You may need to use a package like 'http_parser' to encode files.
//   //   // This will depend on your specific use case and file format.
//   //   // For example, for uploading image files, you can use 'http_parser' or 'dio' package.
//   //   // Replace this with your actual implementation.
//   //   return 'encoded_file_data';
//   // }

//   // void main() async {
//   //   try {
//   //     final result = await identifyPlant(['image1.jpg', 'image2.jpg']);
//   //     print(result);
//   //   } catch (e) {
//   //     print('Error: $e');
//   //   }
//   // }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlantApi {
  Future<Map<String, dynamic>> identifyPlant(String imageUrl) async {
    print('Identifying plant...');
    const String apiKey = "GRNTolRKPjkhh3GtVnlgaEvLIrRPsmUaH0odzDbLyyA1m2bYdJ";
    const String apiUrl = "https://api.plant.id/v2/health_assessment";

    final List<String> imageUrls = [imageUrl];

    final List<String> base64Images = await Future.wait(
      imageUrls.map((imageUrl) async {
        return await encodeImageFromUrl(imageUrl);
      }),
    );

    final Map<String, dynamic> params = {
      "images": base64Images,
      "latitude": 49.1951239,
      "longitude": 16.6077111,
      "datetime": 1582830233,
      "language": "en",
      "disease_details": [
        "cause",
        "common_names",
        "classification",
        "description",
        "treatment",
      ],
    };

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Api-Key": apiKey,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(params),
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to identify plant: ${response.statusCode}');
    }
  }

  Future<String> encodeImageFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return base64Encode(bytes);
    } else {
      throw Exception(
          'Failed to fetch and encode image: ${response.statusCode}');
    }
  }
}
