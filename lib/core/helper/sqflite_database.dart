import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/invoice/invoice_model.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/data/model/void_items/void_items_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

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
          'CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT, productId INTEGER, name TEXT, price TEXT, category TEXT, uom TEXT, imagePath TEXT, quantity INTEGER, totalAmount REAL, discountAmount REAL, isDiscountInPercent INTEGER)',
        );
        db.execute(
          'CREATE TABLE invoice_history(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, totalAmount TEXT, checkoutTime TEXT, paymentMethod TEXT, productDetails TEXT)',
        );
        db.execute(
          'CREATE TABLE voidItems(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, totalAmount TEXT, checkoutTime TEXT, paymentMethod TEXT, productDetails TEXT)',
        );
      },
      version: 17,
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

  Future<void> insertCartItem(ProductModel product, int quantity, String totalAmount, double discountAmount, bool isDiscountInPercentOrNot) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    print(isDiscountInPercentOrNot);
    print("from sqf...........................................");
    await _database.insert('cart', {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'category': product.category,
      'uom': product.uom,
      'imagePath': product.imagePath,
      'quantity': quantity,
      'totalAmount': totalAmount.toString(),
      'discountAmount': discountAmount,
      'isDiscountInPercent': isDiscountInPercentOrNot ? 1 : 0,
    });
  }

  Future<void> insertCheckoutHistory(List<CartProductModel> cartProductList, String paymentMethod, int transactionId) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    double grandTotal = 0.0;
    print(transactionId);
    print("this is transection id");
    for (var cartItem in cartProductList) {
      grandTotal += double.parse(cartItem.totalAmount.toString());
    }

    String getProductDetails(List<CartProductModel> cartProductList) {
      List<String> details = cartProductList.map((cartItem) {
        return '${cartItem.name}: ${cartItem.totalAmount}';
      }).toList();

      return details.join(', ');
    }

    try {
      int invoiceId = await _database.insert('invoice_history', {
        'invoiceId': transactionId,
        'totalAmount': grandTotal.toString(),
        'checkoutTime': DateTime.now().toString(),
        'paymentMethod': paymentMethod,
        'productDetails': getProductDetails(cartProductList),
      });
      print(cartProductList.length);
      print(cartProductList);
    } catch (e) {
      print("Error during insertCheckoutHistory: $e");
    }
  }

  Future<List<InvoiceDetailsModel>> getProductsByTransactionId(int transactionId) async {
    print('single transaction called');
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    print('single transaction database initialize');
    final List<Map<String, dynamic>> maps = await _database.query(
      'invoice_history',
      where: 'id = ?',
      whereArgs: [transactionId],
    );

    print('invoice details data:${maps.toString()}');

    List<InvoiceDetailsModel> products = [];
    for (var map in maps) {
      String productDetails = map['productDetails'];

      List<String> items = productDetails.split(', ');

      for (String item in items) {
        List<String> parts = item.split(': ');
        print(parts);
        print("this is part");

        // Check if totalAmount is present in parts
        double? totalAmount;
        if (parts.length > 2) {
          totalAmount = double.tryParse(parts[2]);
        }

        // Add a new InvoiceDetailsModel for each item
        products.add(InvoiceDetailsModel(
          name: parts[0],
          price: parts[1],
          totalAmount: totalAmount,
        ));
      }
    }

    return products;
  }

  Future<List<InvoiceProductModel>> getInvoiceList() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database.query('invoice_history');
    print('invoice list: ${maps.toString()}');
    return List.generate(maps.length, (index) {
      return InvoiceProductModel.fromMap(maps[index]);
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

  Future<void> insertProduct(String name, String price, String category, String uom, String imagePath, String stocks, String wholesalePrice, String mrp, String purchasePrice) async {
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
Future<void> deleteInvoiceByTransactionId(int transactionId) async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  try {
    // Fetch the invoice details using transactionId
    List<InvoiceDetailsModel> products = await getProductsByTransactionId(transactionId);

    if (products.isNotEmpty) {
      // Delete the invoice from the 'invoice_history' table
      await _database.delete(
        'invoice_history',
        where: 'invoiceId = ?',  // Change 'id' to 'invoiceId'
        whereArgs: [transactionId],
      );
      print("Invoice deleted successfully.....");

      // Insert the voided items into the 'voidItems' table
      for (var product in products) {
        await _database.insert('voidItems', {
          'invoiceId': transactionId,
          'totalAmount': product.totalAmount?.toString() ?? '0.0', // Handle null values
          'checkoutTime': DateTime.now().toString(),
          'paymentMethod': 'VOIDED', 
          'productDetails': '${product.name ?? 'Unknown'}: ${product.price?.toString() ?? '0.0'}', // Handle null values
        });
      }
      print("Voided items inserted successfully.....");
    } else {
      print("No products found for the given transactionId.");
    }
  } catch (e) {
    print("Error during deleteInvoiceByTransactionId: $e");
  }
}



  
Future<List<VoidItemsModel>> getVoidedItems() async {
  if (!isDatabaseInitialized()) {
    throw Exception("Database not initialized");
  }

  final List<Map<String, dynamic>> maps = await _database.query('voidItems');
  return List.generate(maps.length, (index) {
    return VoidItemsModel.fromMap(maps[index]);
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

  Future<void> updateProduct(int id, String newName, String price, String newCategory, String newUom, String newImagePath, String newStocks, String newWholeSalePrice, String newPurchasePrice) async {
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
        'stock': newStocks,
        'wholesalePrice': newWholeSalePrice,
        'purchasePrice': newPurchasePrice,
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
