import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'cart_model.dart';

class CartDB {
  static final CartDB instance = CartDB._init();
  static Database? _database;

  CartDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("cart.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY,
        name TEXT,
        price REAL,
        quantity INTEGER
      )
    ''');
  }

  Future<void> addItem(CartItem item) async {
    final db = await instance.database;

    await db.insert(
      'cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateQuantity(int id, int quantity) async {
    final db = await instance.database;

    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> removeItem(int id) async {
    final db = await instance.database;
    await db.delete('cart', where: "id = ?", whereArgs: [id]);
  }

  Future<List<CartItem>> getItems() async {
    final db = await instance.database;
    final result = await db.query('cart');
    return result.map((e) => CartItem.fromMap(e)).toList();
  }
}
