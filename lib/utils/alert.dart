import 'package:flutter/material.dart';

alert(BuildContext context,String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("carros"),
          content: Text(msg),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    },
  );
}