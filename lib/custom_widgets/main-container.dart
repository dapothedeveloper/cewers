// import 'package:cewers/custom_widgets/cewer_title.dart';
// import 'package:cewers/localization/localization_constant.dart';

// import 'package:flutter/material.dart';

// class _MainContainer_ extends StatefulWidget {
//   final Widget child;
//   final Widget bottomNavigationBar;
//   final BoxDecoration decoration;
//   final CewerAppBar displayAppBar;

//   MainContainer({
//     Key key,
//     @required this.decoration,
//     @required this.child,
//     this.displayAppBar,
//     this.bottomNavigationBar,
//   }) : super(key: key);
//   _MainContainer createState() => _MainContainer();
// }

// class _MainContainer extends State<MainContainer> {
//   Locale _locale;

//   @override
//   void didChangeDependencies() {
//     getLocale().then((locale) {
//       _locale = locale;
//     });
//     super.didChangeDependencies();
//   }

//   void setLocale(Locale newLocale) {
//     setState(() {
//       _locale = newLocale;
//     });
//   }

//   @override
//   void initState() {
//     getLocale().then((locale) {
//       _locale = locale;
//     });
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return MaterialApp(
//         locale: _locale,
//         debugShowCheckedModeBanner: false,
//         localizationsDelegates: localizationsDelegates,
//         localeResolutionCallback: localeResolutionCallback,
//         supportedLocales: supportedLocales,
//         theme: Theme.of(context),
//         home: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             // title: Text(translate(context, HOME)),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             actions: <Widget>[
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                 child: DropdownButton(
//                     underline: SizedBox(),
//                     icon: Icon(
//                       Icons.language,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     items: languages
//                         .map(
//                           (item) => DropdownMenuItem(
//                             value: item,
//                             child: Text(
//                               item.languageTitle,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .subtitle2
//                                   .apply(color: Theme.of(context).primaryColor),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (languageCode) {
//                       changeLanguage(languageCode, context);
//                     }),
//               ),
//             ],
//           ),
//           body: Container(
//             // height: MediaQuery.of(context).size.height,
//             decoration: widget.decoration,
//             child: SafeArea(
//               minimum: EdgeInsets.only(left: 24, right: 24, top: 0),
//               child: widget.child,
//             ),
//           ),
//           bottomNavigationBar: widget.bottomNavigationBar,
//         ));
//   }
// }
