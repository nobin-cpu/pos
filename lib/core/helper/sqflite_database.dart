import 'package:flutter_prime/core/helper/date_converter.dart';
import 'package:flutter_prime/data/model/cart/cart_product_model.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';
import 'package:flutter_prime/data/model/customers/customer_model.dart';
import 'package:flutter_prime/data/model/damage_history/damage_history_model.dart';
import 'package:flutter_prime/data/model/damage_history_details/damage_history_details_model.dart';
import 'package:flutter_prime/data/model/invoice/invoice_model.dart';
import 'package:flutter_prime/data/model/invoice_details/invoice_details_model.dart';
import 'package:flutter_prime/data/model/product/product_model.dart';
import 'package:flutter_prime/data/model/uom/uom_model.dart';
import 'package:flutter_prime/data/model/void_items/void_items_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;
  Database get database => _database;
  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'product_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE IF NOT EXISTS uom(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)',
        );
        db.execute(
          'CREATE TABLE IF NOT EXISTS category(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT,imagePath TEXT,)',
        );
        db.execute(
          'CREATE TABLE IF NOT EXISTS product(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,price TEXT, category TEXT, uom TEXT, imagePath TEXT,stock TEXT,wholesalePrice TEXT,mrp TEXT,purchasePrice TEXT)',
        );
        db.execute(
          'CREATE TABLE IF NOT EXISTS cart(id INTEGER PRIMARY KEY AUTOINCREMENT, productId INTEGER, name TEXT, price TEXT, category TEXT, uom TEXT, imagePath TEXT, quantity INTEGER, totalAmount REAL, discountAmount REAL, isDiscountInPercent INTEGER)',
        );
        db.execute('''
        CREATE TABLE IF NOT EXISTS invoice_history(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, totalAmount TEXT,totalDiscountAmount TEXT, checkoutTime TEXT,  paymentMethod TEXT, productDetails TEXT,status TEXT,vatAmount TEXT,setteledVat TEXT,settledVatFormat INTEGER,selectedCustomerId TEXT)''');
        db.execute('CREATE TABLE IF NOT EXISTS product_details('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'invoiceId INTEGER, '
            'checkoutTime TEXT, '
            'productId INTEGER, '
            'productName TEXT, '
            'quantity INTEGER, '
            'totalAmount TEXT, '
            'productPrice TEXT, '
            'discountAmount TEXT,grandTotal DOUBLE,uom TEXT,isDiscountInPercent INTEGER,vatAmount TEXT,vatInpercentOrNot INTEGER,setteledVat TEXT,settledVatFormat INTEGER,selectedCustomerId TEXT)');

        db.execute(
          'CREATE TABLE IF NOT EXISTS voidItems(id INTEGER PRIMARY KEY AUTOINCREMENT, invoiceId INTEGER, totalAmount TEXT, checkoutTime TEXT, paymentMethod TEXT, productDetails TEXT)',
        );

        db.execute('''
        CREATE TABLE IF NOT EXISTS damage_history(id INTEGER PRIMARY KEY AUTOINCREMENT, damageID INTEGER,  creationTime TEXT,productID INTEGER )''');
        db.execute('CREATE TABLE IF NOT EXISTS damage_details('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'damageID INTEGER, '
            'creationTime TEXT, '
            'productName TEXT, '
            'quantity INTEGER,'
            'productID INTEGER,'
            'damageReason TEXT ');
        db.execute(
          'CREATE TABLE IF NOT EXISTS customers(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,address TEXT,phNo TEXT,post TEXT)',
        );

        print('Table damage_details created successfully.');
      },
      version: 40,
    );
  }

  Future<void> insertUom(UomModel uom) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    await _database.insert('uom', uom.toMap());
  }

  Future<void> insertDamageDetails(int damageId, String productName, String checkoutTime, int quantity, int productID, String damageReason) async {
    print("this is ");
    print(damageId);
    print(productName);
    print(checkoutTime);
    print(quantity);
    print("this is ----------------------------------------------");

    try {
      if (!isDatabaseInitialized()) {
        throw Exception("Database not initialized");
      }

      await _createDamageDetailsTableIfNotExists();
      await _createDamageHiostoryTableIfNotExists();

      await _database.insert('damage_history', {
        'damageID': damageId,
        'creationTime': checkoutTime,
        'productID': productID,
      });
      await _database.insert('damage_details', {
        'damageID': damageId,
        'creationTime': checkoutTime,
        'productName': productName,
        'quantity': quantity,
        'productID': productID,
        'damageReason': damageReason,
      });

      print("Damage item added successfully");
    } catch (e) {
      print('Error inserting damage details: $e');
      throw e;
    }
  }

// Future<void> insertDamageDetails(int damageId, int productId, String productName, int quantity) async {
//   if (!isDatabaseInitialized()) {
//     throw Exception("Database not initialized");
//   }

//   try {
//     await _database.insert('damage_details', {
//       'damageId': damageId,
//       'productId': productId,
//       'productName': productName,
//       'quantity': quantity,
//     });

//     print("Damage details added successfully");
//   } catch (e) {
//     print("Error during insertDamageDetails: $e");
//   }
// }

  Future<void> _createDamageDetailsTableIfNotExists() async {
    await _database.execute(
      'CREATE TABLE IF NOT EXISTS damage_details('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'damageID INTEGER, '
      'creationTime TEXT, '
      'productName TEXT, '
      'quantity INTEGER, '
      'productID INTEGER ,'
      'damageReason TEXT '
      ')',
    );
  }

  Future<void> _createDamageHiostoryTableIfNotExists() async {
    await _database.execute(
      'CREATE TABLE IF NOT EXISTS damage_history(id INTEGER PRIMARY KEY AUTOINCREMENT, damageID INTEGER,  creationTime TEXT ,productID INTEGER)',
    );
  }

  Future<List<DamageHistoryItem>> getDamageHistory() async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database.query('damage_history');

    return List.generate(maps.length, (index) {
      return DamageHistoryItem(
        id: maps[index]['id'],
        damageID: maps[index]['damageID'],
        creationTime: maps[index]['creationTime'],
      );
    });
  }

  Future<List<DamageDetailItem>> getAllDamageItems(DateTime selectedDate, bool isFilteringByMonth) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    if (isFilteringByMonth) {
      final startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
      final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
      final List<Map<String, dynamic>> maps = await _database.query('damage_details', where: 'creationTime BETWEEN ? AND ?', whereArgs: [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()]);

      return List.generate(maps.length, (index) {
        DateTime creationDateTime = DateTime.parse(maps[index]['creationTime']);
        return DamageDetailItem(
          id: maps[index]['id'],
          damageID: maps[index]['damageID'],
          creationTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(creationDateTime),
          productName: maps[index]['productName'],
          quantity: maps[index]['quantity'],
          damageReason: maps[index]['damageReason'],
        );
      });
    } else {
      final List<Map<String, dynamic>> maps = await _database.query('damage_details', where: 'creationTime LIKE ?', whereArgs: ['${DateFormat('yyyy-MM-dd').format(selectedDate)}%']);

      return List.generate(maps.length, (index) {
        DateTime creationDateTime = DateTime.parse(maps[index]['creationTime']);
        return DamageDetailItem(
          id: maps[index]['id'],
          damageID: maps[index]['damageID'],
          creationTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(creationDateTime),
          productName: maps[index]['productName'],
          quantity: maps[index]['quantity'],
          damageReason: maps[index]['damageReason'],
        );
      });
    }
  }

  Future<List<DamageDetailItem>> getAllDamageItemsByMonth(DateTime selectedDate) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    final startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    final List<Map<String, dynamic>> maps = await _database.query('damage_details', where: 'creationTime BETWEEN ? AND ?', whereArgs: [startOfMonth.toString(), endOfMonth.toString()]);

    return List.generate(maps.length, (index) {
      print("this is date========================================================== ${maps[index]['creationTime']}");

      DateTime creationDateTime = DateTime.parse(maps[index]['creationTime']);

      return DamageDetailItem(
        id: maps[index]['id'],
        damageID: maps[index]['damageID'],
        creationTime: creationDateTime.toIso8601String(),
        productName: maps[index]['productName'],
        quantity: maps[index]['quantity'],
        damageReason: maps[index]['damageReason'],
      );
    });
  }

  Future<List<DamageDetailItem>> getDamageDetails(int damageID) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      'damage_details',
      where: 'damageID = ?',
      whereArgs: [damageID],
    );

    return List.generate(maps.length, (index) {
      return DamageDetailItem(
        id: maps[index]['id'],
        damageID: maps[index]['damageID'],
        creationTime: maps[index]['creationTime'],
        productName: maps[index]['productName'],
        quantity: maps[index]['quantity'],
        damageReason: maps[index]['damageReason'],
      );
    });
  }

  Future<void> insertCategory(String categoryTitle, String imagePath) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    await _createCategoryTableIfNotExists();

    print("this is title and image path ${categoryTitle} and ${imagePath}");

    await _database.insert('category', {'title': categoryTitle, 'imagePath': imagePath});
  }

  Future<void> _createCategoryTableIfNotExists() async {
    await _database.execute(
      'CREATE TABLE IF NOT EXISTS category(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, imagePath TEXT)',
    );
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

  Future<void> insertCheckoutHistory(List<CartProductModel> cartProductList, String paymentMethod, int transactionId, bool isVoid, int vatAmount, bool isVatInPercent, bool settledVatFormat, String selectedCustomerId) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    double grandTotal = 0.0;
    double totalDiscountAmount = 0.0;
    double productVatAmount = 0.0;

    for (var cartItem in cartProductList) {
      grandTotal += double.parse(cartItem.totalAmount.toString());
      totalDiscountAmount += cartItem.discountAmount ?? 0.0;
      double grandTotalForProduct = cartItem.totalAmount!;
      if (isVatInPercent) {
        productVatAmount = grandTotalForProduct * (vatAmount / 100);
      } else {
        productVatAmount = vatAmount.toDouble();
      }
    }

    try {
      print("this is product details data-------------from ----------------------------------------------------sqffff${productVatAmount.toStringAsFixed(2)}");

      String productVatAmountString = productVatAmount.toStringAsFixed(2).replaceAll(RegExp(r'[^\d.]'), '');

      print("this is product vaaaaaaaats    ========================================${productVatAmountString}");
      int invoiceId = await _database.insert('invoice_history', {
        'invoiceId': transactionId,
        'totalAmount': grandTotal.toString(),
        'totalDiscountAmount': totalDiscountAmount.toString(),
        'checkoutTime': DateTime.now().toString(),
        'paymentMethod': paymentMethod,
        'status': isVoid ? 'VOID' : 'NOT VOID',
        'vatAmount': productVatAmountString,
        'setteledVat': productVatAmount.toStringAsFixed(2),
        'settledVatFormat': settledVatFormat ? 1 : 0,
        'selectedCustomerId': selectedCustomerId.toString(),
      });

      print("Invoice ID: $invoiceId");

      for (var cartItem in cartProductList) {
        double productVatAmount = 0.0;
        double grandTotalForProduct = cartItem.totalAmount!;
        double discountedAmount = 0.0;

        if (cartItem.isDiscountInPercent == 1) {
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
        String productVatAmountString = productVatAmount.toStringAsFixed(2).replaceAll(RegExp(r'[^\d.]'), '');

        print("this is product vaaaaaaaats=================+++++++++++++++++    ========================================${productVatAmountString}");

        await _database.insert('product_details', {
          'invoiceId': transactionId,
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
          'vatAmount': productVatAmountString,
          'vatInPercentOrNot': isVatInPercent ? 1 : 0,
          'setteledVat': productVatAmount.toStringAsFixed(2),
          'settledVatFormat': settledVatFormat ? 1 : 0,
          'selectedCustomerId': selectedCustomerId.toString()
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
            name: productMap['productName'], price: productMap['productPrice'], totalAmount: double.parse(productMap['totalAmount']), quantity: productMap['quantity'], uom: productMap['uom'], discountAmount: double.tryParse(productMap['discountAmount']), grandTotal: productMap['grandTotal'], isDiscountInPercent: productMap['isDiscountInPercent'], invoiceID: productMap['invoiceId']));
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
            invoiceID: productMap['invoiceId']));
      }
      print("working from here 3 ");
      return products;
    } catch (e) {
      print("Error during getFilteredInvoiceDetailsByDateRange: $e");
      return [];
    }
  }

  Future<List<InvoiceDetailsModel>> getFilteredInvoiceList(DateTime date ,bool isfilteredByMonth) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
  print("this is date from controller ${date}");
    final DateTime startDate = isfilteredByMonth?DateTime(date.year, date.month, 1): DateTime(date.year,date.month,date.day);
    final DateTime endDate =isfilteredByMonth?DateTime(date.year, date.month + 1, 0): startDate.add(const Duration(days: 1));

    print("this is start date ${startDate.toIso8601String()}");
    print("this is end date ${endDate.toIso8601String()}");


    final List<Map<String, dynamic>> productData = await _database.rawQuery(
      'SELECT '
      'productName, '
      'productPrice, ''checkoutTime,'
      'SUM(totalAmount) AS totalAmount, '
      'SUM(quantity) AS totalQuantity, '
      'SUM(grandTotal) AS totalGrandTotal, '
      'SUM(discountAmount) AS totalDiscountAmount, '
      'SUM(vatAmount) AS totalVat, '
      '(SELECT SUM(totalAmount) FROM product_details WHERE checkoutTime >= ? AND checkoutTime < ?) AS totalAmountAllProducts, '
      '(SELECT SUM(grandTotal) FROM product_details WHERE checkoutTime >= ? AND checkoutTime < ?) AS totalGrandTotalAllProducts, '
      '(SELECT SUM(vatAmount) FROM product_details WHERE checkoutTime >= ? AND checkoutTime < ?) AS totalVatAllProducts '
      'FROM '
      'product_details '
      'WHERE '
      'checkoutTime >= ? '
      'AND checkoutTime < ? '
      'GROUP BY '
      'productName, '
      'productPrice',
      [startDate.toIso8601String().substring(0, 10), endDate.toIso8601String().substring(0, 10), startDate.toIso8601String().substring(0, 10), endDate.toIso8601String().substring(0, 10), startDate.toIso8601String().substring(0, 10), endDate.toIso8601String().substring(0, 10), startDate.toIso8601String().substring(0, 10), endDate.toIso8601String().substring(0, 10)],
    );

    print("this is product data: ${productData.length} --------$productData");

    if (productData.isEmpty) {
      return [];
    }

    List<InvoiceDetailsModel> products = [];
    double? totalGrandTotalAllProducts;
    double? totalAmountAllProducts;
    double? totalVatAllProducts;
    int i = 0;
    for (var productMap in productData) {
      ++i;
      print('-----------$i');

      totalGrandTotalAllProducts = productMap['totalGrandTotalAllProducts'];
      totalAmountAllProducts = productMap['totalAmountAllProducts'];
      totalVatAllProducts = productMap['totalVatAllProducts'];
      print("this is checkout time--------============================================================================================================== ${DateConverter.formatValidityDate(productMap['checkoutTime'].toString())}");

      products.add(InvoiceDetailsModel(
        name: productMap['productName'],
        price: productMap['productPrice'],
        totalAmount: productMap['totalAmount'],
        quantity: productMap['totalQuantity'],
        grandTotal: productMap['totalGrandTotal'],
        discountAmount: productMap['totalDiscountAmount'],
        vatAmount: productMap['totalVat'],
        checkoutTime: productMap['checkoutTime'],
      ));
    }
    products.forEach((product) {
      product.totalGrandTotalofAllProduct = totalGrandTotalAllProducts;
      product.totalPriceofAllProduct = totalAmountAllProducts;
      product.totalVatofAllProduct = totalVatAllProducts;
    });

    return products;
    
  }

  Future<List<InvoiceDetailsModel>> getProductsByTransactionId(int transactionId) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      final List<Map<String, dynamic>> productData = await _database.query(
        'product_details',
        where: 'invoiceId = ?',
        whereArgs: [transactionId],
      );

      print('product details data: ${productData.toString()}');

      List<InvoiceDetailsModel> products = [];

    for (var productMap in productData) {
  products.add(InvoiceDetailsModel(
    name: productMap['productName'],
    price: productMap['productPrice'].toString(),
    totalAmount: double.parse(productMap['totalAmount'].toString()),
    quantity: productMap['quantity'],
    uom: productMap['uom'],
    discountAmount: double.tryParse(productMap['discountAmount'].toString()),
    grandTotal: double.parse(productMap['grandTotal'].toString()), 
    isDiscountInPercent: productMap['isDiscountInPercent'],
    vatAmount: double.parse(productMap['vatAmount'].toString()), 
    productId: int.tryParse(productMap['productId'].toString()),
    settledVat: productMap['setteledVat'].toString(),
    settledVatFormat: productMap['settledVatFormat'],
    selectedCustomerId: productMap['selectedCustomerId'],
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

  Future<void> updateProductStock(int productId, String newStock) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    try {
      await _database.update(
        'product',
        {'stock': newStock},
        where: 'id = ?',
        whereArgs: [productId],
      );
      print('Stock updated successfully');
    } catch (e) {
      print('Error updating stock: $e');
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

  Future<void> insertCustomers(String name, String address, String phNo, String post) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }
    await _database.insert('customers', {
      'name': name,
      'address': address,
      'phNo': phNo,
      'post': post,
    });
    print("success");
  }

  Future<List<CustomerModel>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (index) {
      return CustomerModel(
        id: maps[index]['id'],
        name: maps[index]['name'],
        address: maps[index]['address'],
        phNo: maps[index]['phNo'],
        post: maps[index]['post'],
      );
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
          vatAmount: double.tryParse(productMap['vatAmount'].toString()),
          selectedCustomerId: productMap['selectedCustomerId'],
          invoiceID: productMap['invoiceId'],
        ));
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
    print("this is image for update ${categoryModel.image}");
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

  Future<String> getProductStock(String productId) async {
    if (!isDatabaseInitialized()) {
      throw Exception("Database not initialized");
    }

    List<Map<String, dynamic>> result = await _database.query(
      'product',
      where: 'id = ?',
      whereArgs: [productId],
      columns: ['stock'],
    );

    if (result.isNotEmpty) {
      return result.first['stock'].toString();
    } else {
      return '0';
    }
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

  query(String s) {}
}
