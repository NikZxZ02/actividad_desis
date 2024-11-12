import 'dart:developer';

import 'package:actividad_desis/models/product.dart';
import 'package:actividad_desis/models/sale_slip.dart';
import 'package:actividad_desis/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBSqlite {
  static const String databaseName = 'user_database.db';
  static final DBSqlite _instance = DBSqlite._internal();
  factory DBSqlite() => _instance;

  static Database? _database;

  DBSqlite._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,phoneNumber TEXT,
        birthDate TEXT,
        address TEXT,
        password TEXT,
        latitude REAL,
        longitude REAL 
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL,
        description TEXT NOT NULL,
        unitPrice TEXT NOT NULL,
        active INTEGER NOT NULL
     )
    ''');

    await db.execute('''
      CREATE TABLE sale_slips (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folio INTEGER NOT NULL,
        rut TEXT NOT NULL,
        totalAmount INTEGER NOT NULL,
        date TEXT NOT NULL,
        datetime TEXT NOT NULL,
        sale_slip BLOB NOT NULL
    );
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toJson());
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toJson());
  }

  Future<int> insertSaleSlip(SaleSlip saleSlip) async {
    final db = await database;
    return await db.insert('sale_slips', saleSlip.toJson());
  }

  Future<void> deleteUser(int userId) async {
    final db = await database;
    try {
      await db.delete('users', where: 'id = ?', whereArgs: [userId]);
    } catch (error) {
      log("$error");
    }
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final user = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (user.isNotEmpty) {
      return User.fromMap(user.first);
    } else {
      return null;
    }
  }

  Future<List<Product>> getProducts(String? code, String? description) async {
    final db = await database;
    String whereClause = '';
    List<String> whereArgs = [];

    if (code != null && code.isNotEmpty) {
      whereClause += 'code LIKE ?';
      whereArgs.add('%$code%');
    }

    if (description != null && description.isNotEmpty) {
      if (whereClause.isNotEmpty) {
        whereClause += ' OR ';
      }
      whereClause += 'description LIKE ?';
      whereArgs.add('%$description%');
    }

    final List<Map<String, dynamic>> products = await db.query(
      'products',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return List.generate(products.length, (i) {
      return Product(
        id: products[i]['id'],
        code: products[i]['code'],
        description: products[i]['description'],
        unitPrice: products[i]['unitPrice'],
        active: products[i]['active'],
      );
    });
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        phoneNumber: maps[i]['phoneNumber'],
        birthDate: maps[i]['birthDate'],
        address: maps[i]['address'],
        password: maps[i]['password'],
        coordinates: [
          maps[i]['latitude'],
          maps[i]['longitude'],
        ],
      );
    });
  }

  Future<List<SaleSlip>> getSaleSlips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sale_slips');

    return List.generate(maps.length, (i) {
      return SaleSlip(
        id: maps[i]['id'],
        folio: maps[i]['folio'],
        rut: maps[i]['rut'],
        totalAmount: maps[i]['totalAmount'],
        date: maps[i]['date'],
        datetime: maps[i]['datetime'],
        saleSlip: maps[i]['sale_slip'],
      );
    });
  }
}
