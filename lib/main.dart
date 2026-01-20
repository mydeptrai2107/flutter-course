import 'package:app/admin/presentation/dashboard_screen.dart';
import 'package:app/bottom_nav_basic.dart';
import 'package:app/firebase_options.dart';
import 'package:app/page/login_screens.dart';
import 'package:app/presentation/cart/providers/cart_provider.dart';
import 'package:app/presentation/checkout/providers/checkout_provider.dart';
import 'package:app/presentation/home/providers/home_provider.dart';
import 'package:app/presentation/order/provider/order_history_provider.dart';
import 'package:app/presentation/profile/providers/profile_provider.dart';
import 'package:app/sevices/auth_sevices.dart';
import 'package:app/sevices/notificaton_sevice.dart';
import 'package:app/storage/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'Dev',
  );
  await LocalStorage.init();
  await NotificationService().init();

  // await ProductRepository.loadProductData();
  //await BrandRepository.loadBrandData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => CheckoutProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => OrderHistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService().init();
    final auth = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: auth == null
          ? const LoginScreens()
          : FutureBuilder(
              future: AuthSevices().checkAdmin(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data! ? const DashboardScreen() : BottomNavBasic();
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
    //return MaterialApp(debugShowCheckedModeBanner: false, home: const OrderHistoryPage());
  }
}
