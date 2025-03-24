import 'package:sqflite/sqflite.dart';

import '../../../headers.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();
  Database? database;

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            price TEXT NOT NULL
          )
        ''');
      },
    );
    return database!;
  }

  Future<void> insertCartItem(ProductModel product) async {
    if (database == null) {
      await initDB();
    }
    await database!.insert('cart', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ProductModel>> getCartItems() async {
    if (database == null) {
      await initDB();
    }
    List<Map<String, dynamic>> data = await database!.query('cart');
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> deleteCartItem(String id) async {
    if (database == null) {
      await initDB();
    }
    await database!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }
}
