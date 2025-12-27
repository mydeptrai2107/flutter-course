import 'package:app/repository/auth_repository.dart';
import 'package:app/sevices/dialog_sevices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreens extends StatefulWidget {
  const SignUpScreens({super.key});

  @override
  State<SignUpScreens> createState() => _SignUpScreensState();
}

class _SignUpScreensState extends State<SignUpScreens> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  get DialogServices => null;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
            Text(style: TextStyle(fontSize: 18), 'Tạm biệt thuốc lá'),
            SizedBox(height: 10),
            Text(style: TextStyle(fontSize: 14), 'Chào mừng bạn trở lại!'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                hintText: 'email@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.greenAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10, top: 20),
              child: Text('Mật khẩu'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: '**********',
                prefixIcon: const Icon(Icons.lock_outlined),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.greenAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Xác nhận mật khẩu'),
            ),
            TextFormField(
              controller: _confirmController,
              decoration: InputDecoration(
                hintText: '**********',
                prefixIcon: const Icon(Icons.lock_open_outlined),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.greenAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    style: TextStyle(color: Colors.greenAccent),
                    'Quên mật khẩu?',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final confirm = _confirmController.text;

                      await AuthRepository.register(
                        context: context,
                        email: email,
                        password: password,
                        confirm: confirm,
                      );

                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                        DialogSevices.notificeDialog(
                          context: context,
                          isSuccess: true,
                          content: 'Đăng kys thành công',
                        );
                        await DialogServices.notificeDialog(
                          context: context,
                          isSuccess: true,
                          content: 'Tạo tài khoản thành công',
                        );
                        Navigator.pop(context);
                      } on FirebaseException catch (e) {
                        DialogServices.notificeDialog(
                          context: context,
                          isSuccess: false,
                          content:
                              e.message ?? 'Hệ thống có lỗi. Vui lòng thử lại',
                        );
                      }
                    },
                    child: const Text(
                      style: TextStyle(color: Colors.black),
                      'Đăng ký',
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
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
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        side: const BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(color: Colors.black),
                      'Đăng nhập với Google',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(style: TextStyle(fontSize: 12), 'Đã có tài khoản?'),
                Text(
                  style: TextStyle(fontSize: 12, color: Colors.greenAccent),
                  'Đăng nhập',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
