import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../models/anime_model.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Anime>> getAnimeList() async {
    final uri = Uri.parse('${AppConstants.kitsuBaseUrl}${AppConstants.animeListPath}');

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 20));
      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Status ${response.statusCode}: gagal mengambil daftar anime.');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (decoded['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(Anime.fromJson)
          .toList();
      return data;
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format response API tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<Anime> getAnimeDetail(String animeId) async {
    if (animeId.trim().isEmpty) {
      throw Exception('ID anime tidak valid.');
    }

    final uri = Uri.parse('${AppConstants.kitsuBaseUrl}/anime/$animeId');

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 20));
      if (response.statusCode != HttpStatus.ok) {
        throw Exception('Status ${response.statusCode}: detail anime tidak ditemukan.');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('Data detail anime kosong.');
      return Anime.fromJson(data);
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format response API tidak valid.');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
