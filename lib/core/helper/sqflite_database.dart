import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'product_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE uom(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)',
        );
        db.execute(
          'CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)',
        );
        db.execute(
          'CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,price TEXT, category TEXT, uom TEXT, imagePath TEXT,stock TEXT,wholesalePrice TEXT,mrp TEXT,purchasePrice TEXT)',
        );
        db.execute(
       'CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT, productId INTEGER, name TEXT, price TEXT, category TEXT, uom TEXT, imagePath TEXT, quantity INTEGER, totalAmount REAL)',
       );
        db.execute(
          'CREATE TABLE checkout_history(id INTEGER PRIMARY KEY AUTOINCREMENT, productId INTEGER, name TEXT, price TEXT, category TEXT, uom TEXT, imagePath TEXT, quantity INTEGER, totalAmount REAL, checkoutTime TEXT, paymentMethod TEXT)',
        );
      },
      version: 10,
    );
  }

  Future<void> insertUom(UomModel uom) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    await _database.insert('uom', uom.toMap());
   
  }

  Future<void> insertCategory(String categoryTitle) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    await _database.insert('category', {'title': categoryTitle});
  }

  
   Future<void> insertCartItem(ProductModel product, int quantity,String totalAmount) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.insert('cart', {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'category': product.category,
      'uom': product.uom,
      'imagePath': product.imagePath,
      'quantity': quantity,
      'totalAmount': totalAmount.toString(),
    });
  }
Future<void> insertCheckoutHistory(List<CartProductModel> cartProductList, String paymentMethod) async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  for (var cartItem in cartProductList) {
    await _database.insert('checkout_history', {
      'productId': cartItem.productId,
      'name': cartItem.name,
      'price': cartItem.price,
      'category': cartItem.category,
      'uom': cartItem.uom,
      'imagePath': cartItem.imagePath,
      'quantity': cartItem.quantity,
      'totalAmount': cartItem.totalAmount,
      'checkoutTime': DateTime.now().toString(),
      'paymentMethod': paymentMethod,
    });
  }
}

Future<List<CartProductModel>> getCheckoutHistory() async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  final List<Map<String, dynamic>> maps = await _database.query('checkout_history');
  return List.generate(maps.length, (index) {
    return CartProductModel.fromMap(maps[index]);
  });
}
Future<List<CartProductModel>> getCartItems() async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  final List<Map<String, dynamic>> maps = await _database.query('cart');
  return List.generate(maps.length, (index) {
    return CartProductModel.fromMap(maps[index]);
  });
}


  Future<void> clearCart() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.delete('cart');
  }

  Future<void> updateCartItem(CartProductModel cartItem) async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  await _database.update(
    'cart',
    cartItem.toMap(),
    where: 'id = ?',
    whereArgs: [cartItem.id],
  );
}

Future<void> deleteCartItem(int? id) async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  await _database.delete(
    'cart',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertProduct(String name, String price, String category, String uom, String imagePath,String stocks,String wholesalePrice,String mrp,String purchasePrice) async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }
  await _database.insert('product', {
    'name': name,
    'price': price,
    'category': category,
    'uom': uom,
    'imagePath': imagePath,
    'stock': stocks,
    'wholesalePrice': wholesalePrice,
    'mrp': mrp,
    'purchasePrice': purchasePrice,
  });
}

  Future<List<UomModel>> getUomList() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    final List<Map<String, dynamic>> maps = await _database.query('uom');
    return List.generate(maps.length, (index) {
      return UomModel.fromMap(maps[index]);
    });
  }
Future<List<ProductModel>> getProductsByCategory(String category) async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  final List<Map<String, dynamic>> maps = await _database.query('product', where: 'category = ?', whereArgs: [category]);

  return List.generate(maps.length, (index) {
    return ProductModel.fromMap(maps[index]);
  });
}


    Future<List<CategoryModel>> getCategoryList() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    final List<Map<String, dynamic>> maps = await _database.query('category');
    return List.generate(maps.length, (index) {
      return CategoryModel.fromMap(maps[index]);
    });
  }

  Future<void> updateUom(UomModel uom) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.update(
      'uom',
      uom.toMap(),
      where: 'id = ?',
      whereArgs: [uom.id],
    );
    print(uom.title);
    print(uom.id);
    print("edit section..........................");
  }

  Future<void> updateCategories(CategoryModel categoryModel) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.update(
      'category',
      categoryModel.toMap(),
      where: 'id = ?',
      whereArgs: [categoryModel.id],
    );
    
     print(categoryModel.title);
    print(categoryModel.id);
  }

  Future<void> deleteUom(int id) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.delete(
      'uom',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteCategory(int id) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

Future<List<ProductModel>> getProductList() async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  final List<Map<String, dynamic>> maps = await _database.query('product');
  return List.generate(maps.length, (index) {
    return ProductModel.fromMap(maps[index]);
  });
}

  bool isDatabaseInitialized() {
    return _database.isOpen;
  }

  Future<void> updateProduct(int id, String newName,String price,  String newCategory, String newUom, String newImagePath) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.update(
      'product',
      {
        'name': newName,
        'price': price,
        'category': newCategory,
        'uom': newUom,
        'imagePath': newImagePath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteProduct(int id) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _database.delete(
      'product',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
