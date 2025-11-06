import 'dart:convert';
import 'dart:io';

class JSONStorage {
  final String path;

  JSONStorage(this.path);

  Future<void> save(String filename, Map<String, dynamic> data) async {
    final file = File('$path/$filename');
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(data));
  }

  Future<Map<String, dynamic>?> read(String filename) async {
    final file = File('$path/$filename');
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return jsonDecode(content);
  }

  Future<void> saveList(String filename, List<Map<String, dynamic>> list) async {
    final file = File('$path/$filename');
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(list));
  }

  Future<List<dynamic>?> readList(String filename) async {
    final file = File('$path/$filename');
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return jsonDecode(content);
  }
}
// ai generated, because I dont know to store it in json yet