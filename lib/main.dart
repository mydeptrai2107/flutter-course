import 'package:app/bottom_nav_basic.dart';
import 'package:app/page/login_screens.dart';
import 'package:app/presentation/cart/cart_page.dart';
import 'package:app/repository/auth_repository.dart';
import 'package:app/repository/brand_repository.dart';
import 'package:app/repository/product_repository.dart';
import 'package:app/storage/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();
  // await ProductRepository.loadProductData();
  //await BrandRepository.loadBrandData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    return MaterialApp(debugShowCheckedModeBanner: false, home: auth == null ? const LoginScreens() : const BottomNavBasic());
    //return MaterialApp(debugShowCheckedModeBanner: false, home: const CartPage());
  }
}
