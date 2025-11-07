import 'dart:io';
import 'dart:convert';

class JsonStorage {
  Future<void> saveJson(String path, List data) async {
    final file = File(path);
    await file.writeAsString(jsonEncode(data));
  }

  Future<List> readJson(String path) async {
    final file = File(path);
    if (!file.existsSync()) return [];
    return jsonDecode(await file.readAsString());
  }
}
