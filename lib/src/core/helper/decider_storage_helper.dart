import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DeciderStorageHelper {
  Future<void> saveDecision(
      {required List<String> options, required String selectedOption}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> currentDecisions = prefs.getStringList('decisions') ?? [];

    final newDecision = {
      'options': options,
      'selectedOption': selectedOption,
      'timestamp': DateTime.now().toIso8601String(),
    };

    currentDecisions.add(jsonEncode(newDecision));

    await prefs.setStringList('decisions', currentDecisions);
  }

  Future<List<Map<String, dynamic>>> loadDecisions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedDecisions = prefs.getStringList('decisions') ?? [];

    return storedDecisions.map((decision) {
      return jsonDecode(decision) as Map<String, dynamic>;
    }).toList();
  }
}
