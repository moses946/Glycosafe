import 'dart:convert';

String encodeRequestBodyToBase64(dynamic requestBody) {
  // Convert the request body to a JSON string
  String jsonString = jsonEncode(requestBody);

  // Convert the JSON string to bytes
  List<int> requestBodyBytes = utf8.encode(jsonString);

  // Encode the bytes to base64
  String base64Encoded = base64.encode(requestBodyBytes);

  return base64Encoded;
}
