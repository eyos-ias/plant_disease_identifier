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
      print(json.decode(response.body)['health_assessment']['diseases']);
      return json.decode(response.body)['health_assessment'];
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
