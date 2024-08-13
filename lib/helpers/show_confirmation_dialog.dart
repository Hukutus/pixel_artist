import 'package:flutter/material.dart';

void showConfirmationDialog(
    BuildContext context,
    Function onConfirm,
    [
      String title = 'Confirm Action',
      String content = 'Are you sure you want to proceed?'
    ] ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirm'),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
