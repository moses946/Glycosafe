import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glycosafe_v1/components/endpoints.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map> _sendRefresh(token) async {
    try {
      var url = Endpoints().refresh;

      final body = jsonEncode({
        "refresh": token,
      });

      var request = http.Request("POST", Uri.parse(url));
      request.headers["Content-Type"] = "application/json";
      request.body = body;

      print("sending the request right now");
      var response = await request.send();
      print(response);
      var message = await response.stream.bytesToString();
      print(message);
      try {
        Map<String, dynamic> tokens = jsonDecode(message);
        print(tokens);
        return tokens;
      } on Exception catch (e) {
        print(e);
        return {};
      }
    } on Exception {
      return {};
    }
  }

  Future<List<String?>> getTokens() async {
    var accessToken = await _storage.read(key: 'access_token');
    var refreshToken = await _storage.read(key: 'refresh_token');
    if (accessToken == null || refreshToken == null) {
      return [];
    } else {
      bool accessTokenexpired = JwtDecoder.isExpired(accessToken);
      bool refreshTokenExpired = JwtDecoder.isExpired(refreshToken);

      if (accessTokenexpired && !refreshTokenExpired) {
        var newTokens = await _sendRefresh(refreshToken);
        List<String?> tokens = [newTokens["access"], newTokens["refresh"]];
        if (tokens[0] != null) {
          saveToken(tokens[0]!, "access_token");
          saveToken(tokens[1]!, "refresh_token");
          return tokens;
        } else {
          return [];
        }
      } else if (!accessTokenexpired) {
        List<String?> tokens = [accessToken, refreshToken];
        return tokens;
      } else {
        return [];
      }
    }
  }

  Future<void> saveToken(String token, String key) async {
    await _storage.write(key: key, value: token);
  }

  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }
}
