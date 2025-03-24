import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();
  Database? database;

  void initDB() {}
}
