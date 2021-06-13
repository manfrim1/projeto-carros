

import 'package:flutter/material.dart';

Text text(
  String s,{
  double fontsize =16,
  color = Colors.white,
  bold= false,
}) {
  return Text(
    s ?? "",
    style: TextStyle(
      fontSize: fontsize,
      color: color,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    ),
  );
}
