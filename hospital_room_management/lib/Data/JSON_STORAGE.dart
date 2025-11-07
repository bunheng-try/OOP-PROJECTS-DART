import 'dart:io';
import 'dart:convert';
//AI generated code for JSON storage handling because i'm not confortable with json handling in Dart.
class JsonStorage {
  Future<void> saveJson(String path, List data) async {
    try {
      final file = File(path);
      
      // Create directory if it doesn't exist
      final dir = file.parent;
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      
      // Use formatted JSON for better readability
      final jsonString = JsonEncoder.withIndent('  ').convert(data);
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error saving JSON to $path: $e");
      rethrow;
    }
  }

  Future<List> readJson(String path) async {
    try {
      final file = File(path);
      
      if (!file.existsSync()) {
        return [];
      }
      
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return [];
      }
      
      final data = jsonDecode(content);
      return data is List ? data : [];
    } catch (e) {
      print("Error reading JSON from $path: $e");
      return [];
    }
  }
}