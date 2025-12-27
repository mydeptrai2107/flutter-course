import 'package:app/bottom_nav_basic.dart';
import 'package:app/presentation/home/home_page.dart';
import 'package:app/page/sign_up_screens.dart';
import 'package:app/sevices/dialog_sevices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(style: TextStyle(fontSize: 20), 'Tạm biệt thuốc lá'),
            SizedBox(height: 15),
            Text(
              style: TextStyle(fontSize: 14, color: Colors.grey),
              'Chào mừng bạn trở lại!',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Email'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                hintText: 'email@example.com',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.lightGreenAccent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Mật khẩu'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                hintText: '**********',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.lightGreenAccent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.greenAccent,
                    ),
                    'Quên mật khẩu?',
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      if (email.isEmpty || password.isEmpty) {
                        DialogSevices.notificeDialog(
                          context: context,
                          isSuccess: false,
                          content: 'Vui lòng điền đầy đủ thông tin',
                        );
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        await DialogSevices.notificeDialog(
                          context: context,
                          isSuccess: true,
                          content: 'Đăng nhập thành công',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BottomNavBasic()),
                        );
                      } on FirebaseAuthException catch (e) {
                        DialogSevices.notificeDialog(
                          context: context,
                          isSuccess: false,
                          content: e.message ?? 'Hệ thống lỗi',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(208, 82, 255, 171),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        side: BorderSide.none,
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(color: Colors.black),
                      'Đăng nhập',
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      'hoặc',
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        side: const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(color: Colors.black),
                      'Đặng nhập với Google',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?'),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreens(),
                        ),
                      );
                    },
                    child: const Text(
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 124, 255, 192),
                      ),
                      'Đăng ký ngay',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
