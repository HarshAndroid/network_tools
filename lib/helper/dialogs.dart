import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(
      {required BuildContext context,
      String msg = 'Something Went Wrong(Check Internet)!'}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.blue.withOpacity(.7),
        behavior: SnackBarBehavior.floating));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }
}
