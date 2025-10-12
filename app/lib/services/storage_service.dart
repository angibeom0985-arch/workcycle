import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shift_pattern.dart';

class StorageService {
  static const String _shiftPatternKey = 'shift_pattern';

  Future<void> saveShiftPattern(ShiftPattern pattern) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(pattern.toJson());
    await prefs.setString(_shiftPatternKey, jsonString);
  }

  Future<ShiftPattern?> loadShiftPattern() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_shiftPatternKey);
    
    if (jsonString == null) return null;
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ShiftPattern.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearShiftPattern() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_shiftPatternKey);
  }
}
