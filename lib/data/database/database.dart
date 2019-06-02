import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:language_app/data/entities/word.dart';

class DBHelper {
  static const DB_VERSION = 1;
  static const DB_NAME = "languages.db";

  //Fields
  static const WORD_TABLE = "words";
  static const WORD_ID = "word_id";
  static const WORD_SPANISH = "word_spanish";
  static const WORD_TRANSLATION = "word_translation";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path, version: DB_VERSION, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $WORD_TABLE(" +
        "$WORD_ID INTEGER PRIMARY KEY," +
        "$WORD_SPANISH TEXT," +
        "$WORD_TRANSLATION TEXT" +
        ");");
  }

  Future<List<Word>> getWords() async {
    var dataBase = await db;
    List<Map> dataBaseWords = await dataBase.rawQuery('SELECT * FROM $WORD_TABLE');

    List<Word> words = List();

    for (int i = 0; i < dataBaseWords.length; i++) {
      words.add(Word(dataBaseWords[i][WORD_SPANISH], dataBaseWords[i][WORD_TRANSLATION]));
    }

    return words;
  }

  saveWord(Word word) async {
    var dbClient = await db;
    await dbClient.transaction((transaction) async {
      return await transaction.rawInsert(
          'INSERT INTO $WORD_TABLE($WORD_SPANISH, $WORD_TRANSLATION) VALUES(?, ?)',
          [word.spanishWord, word.englishTranslation]);
    });
  }
}