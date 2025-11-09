import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/CraftsmanModel.dart';

class CraftsmanRepository {
  final String baseUrl = "http://127.0.0.1:8000/api"; // عدّلي المسار حسب مشروعك

  Future<List<CraftsmanModel>> fetchNearbyCrafstman(double lat, double lng) async {
    final response = await http.get(
      Uri.parse('$baseUrl/nearby-artisans?latitude=$lat&longitude=$lng'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CraftsmanModel.fromJson(e)).toList();
    } else {
      throw Exception('فشل تحميل الحرفيين القريبين');
    }
  }
}
