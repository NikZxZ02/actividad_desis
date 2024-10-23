import 'package:flutter/material.dart';

class MessagesStatus {
  static void showStatusMessage(
      BuildContext context, String status, bool isError) {
    final scaffold = ScaffoldMessenger.of(context);

    scaffold.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: isError ? Colors.red[300] : Colors.green[300],
        content: Text(
          status,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
