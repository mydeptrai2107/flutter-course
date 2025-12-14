import 'package:app/bottom_nav_basic.dart';
import 'package:app/page/sign_up_screens.dart';
import 'package:app/services/dialog_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
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
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('Email'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                hintText: 'email@example.com',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.lightGreenAccent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Mật khẩu'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: Icon(Icons.remove_red_eye_outlined),
                hintText: '**********',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.lightGreenAccent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 45),
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
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        DialogServices.notificeDialog(
                          context: context,
                          isSuccess: false,
                          content: "Vui lòng điền đầy đủ email và mật khẩu",
                        );
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavBasic(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        print('❌ Lỗi Firebase: ${e.code} - ${e.message}');

                        String errorMessage = 'Lỗi ';
                        if (e.code == 'invalid-credential') {
                          errorMessage = 'Email hoặc mật khẩu không đúng';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'Email không hợp lệ';
                        } else if (e.code == 'user-disabled') {
                          errorMessage = 'Tài khoản đã bị khóa';
                        }

                        DialogServices.notificeDialog(
                          context: context,
                          isSuccess: false,
                          content: errorMessage,
                        );
                      } catch (e) {
                        DialogServices.notificeDialog(
                          context: context,
                          isSuccess: false,
                          content: 'Lỗi : $e',
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
                    child: Text(
                      style: TextStyle(color: Colors.black),
                      'Đăng nhập',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                        side: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    child: Text(
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
                  Text('Chưa có tài khoản?'),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreens(),
                        ),
                      );
                    },
                    child: Text(
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 124, 255, 192),
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
