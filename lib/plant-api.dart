// var headers = {
//   'Api-Key': 'GRNTolRKPjkhh3GtVnlgaEvLIrRPsmUaH0odzDbLyyA1m2bYdJ',
//   'Content-Type': 'application/json'
// };
// var request = http.Request('POST', Uri.parse('https://plant.id/api/v3/health_assessment?language=en&details=local_name,description,url,treatment,classification,common_names,cause'));
// request.body = json.encode({
//   "images": [
//     "http://res.cloudinary.com/dw5j5q9jz/image/upload/v1695111983/public/udcalkrasbe9kyaucnme.jpg"
//   ],
//   "latitude": 49.207,
//   "longitude": 16.608,
//   "similar_images": true
// });
// request.headers.addAll(headers);

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }
