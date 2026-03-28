// lib/services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _scansKey = 'scans';

  Future<void> saveScan(ScanResult scan) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scansJson = prefs.getStringList(_scansKey) ?? [];
    scansJson.add(json.encode(scan.toJson()));
    await prefs.setStringList(_scansKey, scansJson);
  }

  Future<List<ScanResult>> getScans() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scansJson = prefs.getStringList(_scansKey) ?? [];
    return scansJson.map((jsonStr) => ScanResult.fromJson(json.decode(jsonStr))).toList();
  }

  Future<void> deleteScan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> scansJson = prefs.getStringList(_scansKey) ?? [];
    scansJson.removeWhere((jsonStr) {
      final scan = ScanResult.fromJson(json.decode(jsonStr));
      return scan.id == id;
    });
    await prefs.setStringList(_scansKey, scansJson);
  }

  Future<void> clearAllScans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scansKey);
  }
}