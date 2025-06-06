import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activityDb.db');

    // print("go to delete db %%%");
    // await deleteDatabase(path);
    // return await openDatabase(path);

    var exists = await databaseExists(path);
    print("exists----: $exists");

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "activityDb.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      print("db copyyyy----ok");
    } else {
      // await deleteDatabase(path); //<<<<<<--------
      // print('here-----deleted');
    }

    return await openDatabase(path);
  }
}
