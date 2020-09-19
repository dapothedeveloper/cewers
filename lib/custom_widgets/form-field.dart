import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final double bottomMargin;
  final double width;
  final double height;
  final TextFormField textFormField;
  FormTextField(
      {Key key,
      this.bottomMargin,
      this.textFormField,
      this.width,
      this.height});
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: bottomMargin ?? 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(padding: EdgeInsets.all(10), child: textFormField),
    );
  }
}
