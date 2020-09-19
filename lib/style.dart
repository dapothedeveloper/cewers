import 'package:flutter/material.dart';

const double largeTextSize = 32;
const double mediumTextSize = 26;
const double normalTextSize = 18;
const double smallTextSize = 12;

const String fontPlayFair = "Playfair";
const String fontRoboto = "Roboto";

const Color primaryColor = Color.fromRGBO(178, 2, 42, 1);
const Color secondaryColor = Color.fromRGBO(29, 42, 56, 1);
const Color benueColor = Color.fromRGBO(29, 43, 57, 1);
const Color nasarawaColor = Color.fromRGBO(9, 80, 156, 1);

TextStyle appBarStyle() {
  return TextStyle(
      fontFamily: fontPlayFair,
      fontWeight: FontWeight.w500,
      fontSize: mediumTextSize,
      fontStyle: FontStyle.italic);
}

TextStyle titleStyle() {
  return TextStyle(
      fontFamily: fontPlayFair,
      fontWeight: FontWeight.w700,
      fontSize: largeTextSize,
      fontStyle: FontStyle.normal);
}

TextStyle subHeadStyle(BuildContext context) {
  return TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.w700,
      fontSize: 20);
}

TextStyle coloredHeaderStyle() {
  return TextStyle(
    fontSize: 18,
    fontFamily: fontPlayFair,
    fontWeight: FontWeight.w700,
  );
}

const ButtonStyle = TextStyle(
  fontFamily: fontRoboto,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  fontSize: normalTextSize,
);

BoxDecoration bgDecoration([String uri]) {
  return BoxDecoration(
    image: uri == null
        ? null
        : DecorationImage(
            image: AssetImage(uri),
            fit: BoxFit.cover,
          ),
  );
}

InputDecoration formDecoration(String placeholder, String icon,
        [String errorMessage]) =>
    InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        prefixIcon: icon == null
            ? ImageIcon(AssetImage("assets/icons/person.png"))
            : ImageIcon(AssetImage(icon)),
        hintText: placeholder,
        errorText: errorMessage ?? null);
