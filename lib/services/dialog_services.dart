import 'package:flutter/material.dart';

class DialogServices {
  static notificeDialog({
    required BuildContext context,
    required bool isSuccess,
    required String content,
  }) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isSuccess ? Colors.green : Colors.red,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSuccess ? 'Thành công' : 'Thất bại',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  content,
                  style: TextStyle(
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

    await Future.delayed(Duration(milliseconds: 1500));

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
