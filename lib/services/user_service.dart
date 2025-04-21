import 'dart:convert';
import 'dart:io';
import 'package:diplooajil/include.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class UserService {
  final String baseUrl = baseurl;

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('Making request to: ${baseUrl}users/profile/');
      print('Using token: $token');

      final response = await http.get(
        Uri.parse('${baseUrl}users/profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load user profile: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting user profile: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfileImage(File imageFile) async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('Making image upload request to: ${baseUrl}users/profile/image/');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}users/profile/image/'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          imageFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Upload response status: ${response.statusCode}');
      print('Upload response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to update profile image: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating profile image: $e');
    }
  }
}
