import 'package:lamis/models/models.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sql;

class CartService {
  static Future<sql.Database> cartDb() async {
    return sql.openDatabase(
      'inCart.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE cartItems(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user_id INTEGER,
        product_id INTEGER,
        product_name TEXT,
        product_thumbnail_image TEXT,
        variation TEXT,
        price REAL,
        currency_symbol TEXT,
        quantity INTEGER,
        upper_limit INTEGER
      )
      """);
  }

  // Create new item (journal)
  static Future<int> createItem(int quantity, DetailedProduct item, int userId,
      String variant, int limit) async {
    final db = await CartService.cartDb();

    final data = {
      'user_id': userId,
      'product_id': item.id.toString(),
      'product_name': item.name,
      'product_thumbnail_image': item.thumbnailImage,
      'variation': variant,
      'price': (quantity * item.calculablePrice).toString(),
      'currency_symbol': item.currencySymbol,
      'quantity': quantity,
      'upper_limit': limit,
    };

    final bool = await db.query('cartItems',
        where: "product_id = ?", whereArgs: [item.id], limit: 1);
    if (quantity == 0) {
      return 0;
    } else {
      if (bool.isEmpty) {
        final id = await db.insert('cartItems', data,
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
        return id;
      } else {
        int? id = 0;
        for (var element in bool) {
          id = (element['id'] ?? 0) as int?;
        }
        final data = {
          'quantity': quantity,
          'user_id': userId,
          'product_id': item.id.toString(),
          'product_name': item.name,
          'product_thumbnail_image': item.thumbnailImage,
          'variation': variant
        };
        final result = await db
            .update('cartItems', data, where: "id = ?", whereArgs: [id]);
        return result;
      }
    }
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await CartService.cartDb();
    return db.query('cartItems', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await CartService.cartDb();
    return db.query('cartItems', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, int quantity, CartItem? item, int userId, String variant) async {
    final db = await CartService.cartDb();

    final data = {
      'quantity': quantity,
      'user_id': userId,
      'product_id': item!.id.toString(),
      'product_name': item.productName,
      'product_thumbnail_image': item.productThumbnailImage,
      'variation': variant
    };

    final result =
        await db.update('cartItems', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await CartService.cartDb();

    try {
      await db.delete("cartItems", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      ("Something went wrong when deleting an item: $err");
    }
  }
}
