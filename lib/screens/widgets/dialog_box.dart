import 'package:flutter/material.dart';

class DialogBox {
  information(BuildContext context, String title, String desc) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(desc),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  return Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
