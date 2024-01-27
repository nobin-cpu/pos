import 'package:flutter_prime/view/components/bottom-nav-bar/bottom_nav_bar.dart';
import 'package:flutter_prime/view/screens/account/change-password/change_password_screen.dart';
import 'package:flutter_prime/view/screens/auth/login/login_screen.dart';
import 'package:flutter_prime/view/screens/auth/registration/registration_screen.dart';
import 'package:flutter_prime/view/screens/cart/cart_screen.dart';
import 'package:flutter_prime/view/screens/category/category_screen.dart';
import 'package:flutter_prime/view/screens/category_product_list_screen/category_product_list_screen.dart';
import 'package:flutter_prime/view/screens/cheakout/cheakout_screen.dart';
import 'package:flutter_prime/view/screens/inventory/inventory_screen.dart';
import 'package:flutter_prime/view/screens/confirm_checkout/confirm_checkout_screen.dart';
import 'package:flutter_prime/view/screens/invoice/invoice_screen.dart';
import 'package:flutter_prime/view/screens/invoice_details/invoice_details_screen.dart';
import 'package:flutter_prime/view/screens/pos/pos_screen.dart';
import 'package:flutter_prime/view/screens/pos/widgets/pos_category_section.dart';
import 'package:flutter_prime/view/screens/product/product_screen.dart';
import 'package:flutter_prime/view/screens/report/report_screen.dart';
import 'package:flutter_prime/view/screens/settings/settings_screen.dart';
import 'package:flutter_prime/view/screens/splash/splash_screen.dart';
import 'package:flutter_prime/view/screens/stock/stock_screen.dart';
import 'package:flutter_prime/view/screens/uom/uom_screen.dart';
import 'package:get/get.dart';

import '../../view/screens/void_items/void_items_screen.dart';

class RouteHelper{

static const String splashScreen              = "/splash_screen";
static const String onboardScreen             = "/onboard_screen";
static const String loginScreen               = "/login_screen";
static const String forgotPasswordScreen      = "/forgot_password_screen";
static const String changePasswordScreen      = "/change_password_screen";
static const String registrationScreen        = "/registration_screen";
static const String bottomNavBar              = "/bottom_nav_bar";
static const String privacyScreen             = "/privacy-screen";
static const String inventoryScreen           = '/inventory_screen';
static const String uomScreen                 = '/uom_screen';
static const String categoryScreen            = '/category_screen';
static const String productScreen             = '/product_screen';
static const String posScreen                 = '/pos_screen';
static const String posCategoryProductSection = '/pos_category_product_scction';
static const String categoryProductListScreen = '/category_Product_List_Screen';
static const String cartScreen                = '/cart_Screen';
static const String cheakOutScreen            = '/cheak_out_Screen';
static const String confirmCheckoutScreen     = '/confirm_checkout_Screen';
static const String settingsScreen            = '/settings_Screen';
static const String invoiceScreen             = '/invoice_Screen';
static const String invoiceDetailsScreen      = '/invoice_details_Screen';
static const String voidItemsScreen           = '/void_items_Screen';
static const String reportScreen              = '/report_Screen';
static const String stockScreen               = '/stock_Screen';


  List<GetPage> routes = [

    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: changePasswordScreen, page: () => const ChangePasswordScreen()),
    GetPage(name: registrationScreen, page: () => const RegistrationScreen()),
    GetPage(name: bottomNavBar, page: () => const BottomNavBar()),
    GetPage(name: voidItemsScreen, page: () => const VoidItemsScreen()),
    GetPage(name: inventoryScreen, page: () => const InventoryScreen()),
    GetPage(name: uomScreen, page: () => UomScreen()),
    GetPage(name: categoryScreen, page: () => CategoryScreen()),
    GetPage(name: productScreen, page: () => ProductScreen()),
    GetPage(name: posScreen, page: () => const PosScreen()),
    GetPage(name: posCategoryProductSection, page: () => const PosCategorySection()),
    GetPage(name: categoryProductListScreen, page: () => const CategoryProductListScreen()),
    GetPage(name: cartScreen, page: () => const CartScreen()),
    GetPage(name: cheakOutScreen, page: () => const CheckoutScreen()),
    GetPage(name: confirmCheckoutScreen, page: () => const ConfirmCheckOutScreen()),
    GetPage(name: settingsScreen, page: () => const SettingsScreen()),
    GetPage(name: invoiceScreen, page: () => const InvoiceScreen()),
    GetPage(name: invoiceDetailsScreen, page: () => const InvoiceDetailsScreen()),
    GetPage(name: reportScreen, page: () => const ReportScreen()),
    GetPage(name: stockScreen, page: () => const StockScreen()),
  ];
}