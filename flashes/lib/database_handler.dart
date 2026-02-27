import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  late Database db;
  static DatabaseHandler? databaseInstance;

  DatabaseHandler._create(this.db);

  static Future<void> debug() async {
    String path = join(await getDatabasesPath(), 'flashes_database.db');
    deleteDatabase(path);
  }

  static Future<DatabaseHandler> create() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'flashes_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS card_sets(setID INTEGER PRIMARY KEY AUTOINCREMENT, setName TEXT)',
        );
        await db.execute('PRAGMA foreign_keys = 1');
        await db.execute(
          'CREATE TABLE IF NOT EXISTS cards(cardID INTEGER PRIMARY KEY AUTOINCREMENT, cardSet INTEGER, frontText TEXT, backText TEXT, FOREIGN KEY(cardSet) REFERENCES card_sets(setID))',
        );
      },
      version: 1,
    );
    return DatabaseHandler._create(db);
  }

  Future<void> addSet(String setName) async {
    await db.insert('card_sets', {'setName': setName});
    print(db.query('card_sets'));
  }

  Future<void> addCard(int setID, String frontText, String backText) async {
    await db.insert('cards', {
      'cardSet': setID,
      'frontText': frontText,
      'backText': backText,
    });
  }

  Future<void> updateSet(
    bool isEdit,
    int? setID,
    String name
  ) async {
    if (!isEdit) {
      return await addSet(name);
    }
    await db.update(
      'card_sets',
      {'setName': name},
      where: 'setID = ?',
      whereArgs: [setID],
    );
  }

  Future<void> updateCard(
    bool isEdit,
    int? cardID,
    int setID,
    String frontText,
    String backText,
  ) async {
    if (!isEdit) {
      return await addCard(setID, frontText, backText);
    }
    await db.update(
      'cards',
      {'frontText': frontText, 'backText': backText},
      where: 'cardID = ?',
      whereArgs: [cardID],
    );
  }

  Future<List<Map<String, Object?>>> getCardSets() async {
    return db.query('card_sets');
  }

  Future<List<Map<String, Object?>>> getCards(int setID) async {
    return db.query('cards', where: 'cardSet = ?', whereArgs: [setID]);
  }
}
