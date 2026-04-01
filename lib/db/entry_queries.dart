import '../models/entry.dart';
import 'database.dart';

Future<Entry?> getEntry({required int month, required int day}) async {
  final rows = await db.query(
    'entries',
    where: 'month = ? AND day = ?',
    whereArgs: [month, day],
    limit: 1,
  );
  return rows.isEmpty ? null : Entry.fromMap(rows.first);
}
