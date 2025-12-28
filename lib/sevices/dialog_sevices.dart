import 'package:flutter/material.dart';

class DialogSevices {
  static notificeDialog({
    required BuildContext context,
    required bool isSuccess,
    required String content,
  }) async {
    showDialog(
      barrierColor: Colors.transparent, // bỏ nền xám của dialog
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isSuccess ? Colors.green : Colors.red,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSuccess ? 'Thành công' : 'Thất bại',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
