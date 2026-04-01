import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Database? _db;

Database get db {
  assert(_db != null, 'Database not initialised — call initDatabase() first');
  return _db!;
}

Future<void> initDatabase() async {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final dbPath = await _resolveDbPath();
  _db = await openDatabase(dbPath, version: 1);
}

Future<String> _resolveDbPath() async {
  final dir = await getApplicationDocumentsDirectory();
  final dest = p.join(dir.path, 'spad.db');

  if (!File(dest).existsSync()) {
    try {
      final bytes = await rootBundle.load('assets/db/spad.db');
      await File(dest).writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    } catch (_) {
      // No seed DB in assets — sqflite will create a fresh one.
      if (kDebugMode) print('No seed DB found in assets; creating fresh DB.');
    }
  }

  return dest;
}
