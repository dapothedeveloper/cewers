import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/main.dart';
import 'package:cewers/model/localization.dart';
import 'package:flutter/material.dart';
// import 'package:cewers/custom_widgets/cewer_title.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final CewerAppBar displayAppBar;

  CustomAppBar({
    Key key,
    this.displayAppBar,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final List<AppLocalModel> languages = [
    AppLocalModel("English", "US", ENGLISH),
    AppLocalModel("Hausa", "NG", HAUSA),
    AppLocalModel("Jukun", "NG", JUKUN),
    AppLocalModel("Agatu", "NG", AGATU),
    AppLocalModel("Tiv", "NG", TIV),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: widget.displayAppBar ?? CewerAppBar(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                underline: null,
                icon: Icon(Icons.language),
                items: languages
                    .map(
                      (item) => DropdownMenuItem<AppLocalModel>(
                        value: item,
                        child: Text(item.languageTitle),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  _changeLanguage(value, context);
                }),
          ),
        ),
      ],
    );
  }

  void _changeLanguage(AppLocalModel languageCode, BuildContext context) async {
    Locale _temp;
    switch (languageCode.languageCode) {
      case ENGLISH:
        _temp = Locale(languageCode.languageCode, "US");
        break;
      case JUKUN:
        _temp = Locale(languageCode.languageCode, "NG");
        break;
      case TIV:
        _temp = Locale(languageCode.languageCode, "NG");
        break;
      case AGATU:
        _temp = Locale(languageCode.languageCode, "NG");
        break;
      case HAUSA:
        _temp = Locale(languageCode.languageCode, "NG");
        break;
      default:
        _temp = Locale(languageCode.languageCode, "US");
    }
    App.setLocale(context, _temp);

    setState(() {});
  }
}
