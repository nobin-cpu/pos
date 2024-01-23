import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/invoice/invoice_model.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/data/model/void_items/void_items_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  late Database _database;
  Database get database => _database;
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
        db.execute('''
        CREATE TABLE invoice_history(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, totalAmount TEXT,totalDiscountAmount TEXT, checkoutTime TEXT,  paymentMethod TEXT, productDetails TEXT,status TEXT,vatAmount INTEGER)''');
        db.execute('CREATE TABLE product_details('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'invoiceId INTEGER, '
            'checkoutTime TEXT, '
            'productId INTEGER, '
            'productName TEXT, '
            'quantity INTEGER, '
            'totalAmount TEXT, '
            'productPrice TEXT, '
            'discountAmount TEXT,grandTotal DOUBLE,uom TEXT,isDiscountInPercent INTEGER,vatAmount INTEGER,vatInpercentOrNot INTEGER)');

        db.execute(
          'CREATE TABLE voidItems(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, totalAmount TEXT, checkoutTime TEXT, paymentMethod TEXT, productDetails TEXT)',
        );
      },
      version: 26,
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

  Future<void> insertCheckoutHistory(List<CartProductModel> cartProductList, String paymentMethod, int transactionId, bool isVoid, int vatAmount, bool isVatInPercent) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    double grandTotal = 0.0;
    double totalDiscountAmount = 0.0;

    for (var cartItem in cartProductList) {
      grandTotal += double.parse(cartItem.totalAmount.toString());
      totalDiscountAmount += cartItem.discountAmount ?? 0.0;
    }

    print("VAT from database helper: $vatAmount");

    try {
      int invoiceId = await _database.insert('invoice_history', {
        'invoiceId': transactionId,
        'totalAmount': grandTotal.toString(),
        'totalDiscountAmount': totalDiscountAmount.toString(),
        'checkoutTime': DateTime.now().toUtc().toString(),
        'paymentMethod': paymentMethod,
        'status': isVoid ? 'VOID' : 'NOT VOID',
        'vatAmount': vatAmount,
      });

      print("Invoice ID: $invoiceId");

      for (var cartItem in cartProductList) {
        double productVatAmount = 0.0;
        double grandTotalForProduct = cartItem.totalAmount!;
        double discountedAmount = 0.0;

        if (cartItem.isDiscountInPercent ==1) {
          double productPrice = double.parse(cartItem.price.toString());
          double quantity = double.parse(cartItem.quantity.toString());
          double productTotalPrice = productPrice * quantity;
          double discountPercentage = cartItem.discountAmount ?? 0.0;

        
          discountedAmount = (productTotalPrice * discountPercentage) / 100;

        

          print("Discounted amount: $discountedAmount");
        } else {
          discountedAmount = cartItem.discountAmount ?? 0.0;
        }


        if (isVatInPercent) {
          productVatAmount = grandTotalForProduct * (vatAmount / 100);
        } else {
          productVatAmount = vatAmount.toDouble();
        }

        double grandTotalWithVat = grandTotalForProduct + productVatAmount;

        print("this is discounted amount from database  insert cheakout  ${discountedAmount}");
        await _database.insert('product_details', {
          'invoiceId': invoiceId,
          'checkoutTime': DateTime.now().toUtc().toString(),
          'productId': cartItem.productId,
          'productName': cartItem.name,
          'quantity': cartItem.quantity,
          'totalAmount': cartItem.totalAmount.toString(),
          'productPrice': cartItem.price.toString(),
          'discountAmount': discountedAmount.toString(),
          'grandTotal': grandTotalWithVat.toString(),
          'uom': cartItem.uom,
          'isDiscountInPercent': cartItem.isDiscountInPercent,
          'vatAmount': productVatAmount.toString(),
          'vatInPercentOrNot': isVatInPercent ? 1 : 0,
        });
      }
    } catch (e) {
      print("Error during insertCheckoutHistory: $e");
    }
  }

  Future<List<InvoiceDetailsModel>> getMonthWiseInvoiceDetails(int year, int month) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      final DateTime startDate = DateTime(year, month, 1);
      final DateTime endDate = startDate.add(Duration(days: 31));

      final List<Map<String, dynamic>> productData = await _database.query(
        'product_details',
        where: 'checkoutTime >= ? AND checkoutTime < ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      );

      List<InvoiceDetailsModel> products = [];

      for (var productMap in productData) {
        products.add(InvoiceDetailsModel(
          name: productMap['productName'],
          price: productMap['productPrice'],
          totalAmount: double.parse(productMap['totalAmount']),
          quantity: productMap['quantity'],
          uom: productMap['uom'],
          discountAmount: double.tryParse(productMap['discountAmount']),
          grandTotal: productMap['grandTotal'],
          isDiscountInPercent: productMap['isDiscountInPercent'],
        ));
      }

      return products;
    } catch (e) {
      print("Error during getMonthWiseInvoiceDetails: $e");
      return [];
    }
  }

  Future<List<InvoiceDetailsModel>> getFilteredInvoiceDetailsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    print("working from here 1 ");
    try {
      final List<Map<String, dynamic>> productData = await _database.query(
        'product_details',
        where: 'checkoutTime BETWEEN ? AND ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      );

      List<InvoiceDetailsModel> products = [];
      print("working from here 2 ");
      for (var productMap in productData) {
        products.add(InvoiceDetailsModel(
          name: productMap['productName'],
          price: productMap['productPrice'],
          totalAmount: double.parse(productMap['totalAmount']),
          quantity: productMap['quantity'],
          uom: productMap['uom'],
          discountAmount: double.tryParse(productMap['discountAmount']),
          grandTotal: productMap['grandTotal'],
          isDiscountInPercent: productMap['isDiscountInPercent'],
          isvatInpercentOrNot: productMap['isVatInPercent'] == 1 ? true : false,
        ));
      }
      print("working from here 3 ");
      return products;
    } catch (e) {
      print("Error during getFilteredInvoiceDetailsByDateRange: $e");
      return [];
    }
  }

  Future<List<InvoiceDetailsModel>> getFilteredInvoiceDetails(DateTime date) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      final DateTime startDate = DateTime(date.year, date.month, date.day);
      final DateTime endDate = startDate.add(Duration(days: 1));

      final List<Map<String, dynamic>> productData = await _database.query(
        'product_details',
        where: 'checkoutTime >= ? AND checkoutTime < ?',
        whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      );

      List<InvoiceDetailsModel> products = [];

      for (var productMap in productData) {
        products.add(InvoiceDetailsModel(
            name: productMap['productName'],
            price: productMap['productPrice'],
            totalAmount: double.parse(productMap['totalAmount']),
            quantity: productMap['quantity'],
            uom: productMap['uom'],
            discountAmount: double.tryParse(productMap['discountAmount']),
            grandTotal: productMap['grandTotal'],
            isDiscountInPercent: productMap['isDiscountInPercent'],
            vatAmount: productMap['vatAmount'].toString(),
            isvatInpercentOrNot: productMap['vatInpercentOrNot'] == 1 ? true : false));
      }

      return products;
    } catch (e) {
      print("Error during getFilteredInvoiceDetails: $e");
      return [];
    }
  }

  Future<List<InvoiceDetailsModel>> getProductsByTransactionId(int transactionId) async {
    print('single transaction called');
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    print('single transaction database initialize');

    try {
      final List<Map<String, dynamic>> invoiceData = await _database.query(
        'invoice_history',
        where: 'id = ?',
        whereArgs: [transactionId],
      );

      if (invoiceData.isEmpty) {
        return [];
      }

      final List<Map<String, dynamic>> productData = await _database.query(
        'product_details',
        where: 'invoiceId = ?',
        whereArgs: [transactionId],
      );

      print('invoice details data: ${invoiceData.toString()}');
      print('product details data: ${productData.toString()}');

      List<InvoiceDetailsModel> products = [];

      for (var productMap in productData) {
        products.add(InvoiceDetailsModel(
          name: productMap['productName'],
          price: productMap['productPrice'],
          totalAmount: double.parse(productMap['totalAmount']),
          quantity: productMap['quantity'],
          uom: productMap['uom'],
          discountAmount: double.tryParse(productMap['discountAmount']),
          grandTotal: productMap['grandTotal'],
          isDiscountInPercent: productMap['isDiscountInPercent'],
          vatAmount: productMap['vatAmount'],
        ));
      }

      return products;
    } catch (e) {
      print("Error during getProductsByTransactionId: $e");
      return [];
    }
  }

  Future<void> updateInvoiceItemStatus(int itemId, String status) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      await _database.update(
        'invoice_history',
        {'status': status},
        where: 'id = ?',
        whereArgs: [itemId],
      );

      print("Invoice item status updated successfully.");
    } catch (e) {
      print("Error during updateInvoiceItemStatus: $e");
    }
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
    print("i am discount amount from database cart ${cartItem.discountAmount}");
    await _database.update(
      'cart',
      {
        'quantity': cartItem.quantity,
        'totalAmount': cartItem.totalAmount,
        'discountAmount': cartItem.discountAmount,
        'isDiscountInPercent': cartItem.isDiscountInPercent,
      },
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

  Future<List<InvoiceDetailsModel>> getAllInvoiceDetails() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      final List<Map<String, dynamic>> productData = await _database.query(
        'product_details',
      );

      print('product details data: ${productData.toString()}');

      List<InvoiceDetailsModel> products = [];

      for (var productMap in productData) {
        products.add(InvoiceDetailsModel(
            name: productMap['productName'],
            price: productMap['productPrice'],
            totalAmount: double.parse(productMap['totalAmount']),
            quantity: productMap['quantity'],
            uom: productMap['uom'],
            discountAmount: double.tryParse(productMap['discountAmount']),
            grandTotal: productMap['grandTotal'],
            isDiscountInPercent: productMap['isDiscountInPercent'],
            checkoutTime: productMap['checkoutTime'],
            vatAmount: productMap['vatAmount']));
      }

      return products;
    } catch (e) {
      print("Error during getAllInvoiceDetails: $e");
      return [];
    }
  }

  Future<void> deleteInvoiceByTransactionId(Database _database, int transactionId) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      List<InvoiceDetailsModel> products = await getProductsByTransactionId(transactionId);

      if (products.isNotEmpty) {
        await _database.delete(
          'invoice_history',
          where: 'invoiceId = ?',
          whereArgs: [transactionId],
        );
        print("Invoice deleted successfully.....");

        for (var product in products) {
          await _database.insert('voidItems', {
            'invoiceId': transactionId,
            'totalAmount': product.totalAmount?.toString() ?? '0.0',
            'checkoutTime': DateTime.now().toString(),
            'paymentMethod': 'VOIDED',
            'productDetails': '${product.name ?? 'Unknown'}: ${product.price?.toString() ?? '0.0'}',
          });

          // Print the inserted data
          print("Voided item inserted - InvoiceId: $transactionId, TotalAmount: ${product.totalAmount?.toString() ?? '0.0'}, ProductDetails: ${product.name ?? 'Unknown'}: ${product.price?.toString() ?? '0.0'}");
        }
        print("Voided items inserted successfully.....");
      } else {
        print("No products found for the given transactionId.");
      }
    } catch (e) {
      print("Error during deleteInvoiceByTransactionId: $e");
    }
  }

  Future<List<VoidItemsModel>> getVoidedItemsByInvoiceId(int invoiceId) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      'voidItems',
      where: 'invoiceId = ?',
      whereArgs: [invoiceId],
    );

    return List.generate(maps.length, (index) {
      return VoidItemsModel.fromMap(maps[index]);
    });
  }

  Future<List<VoidItemsModel>> getVoidedItems() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database.query('voidItems');
    print("VoidItems from database: $maps");

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
